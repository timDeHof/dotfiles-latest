#!/usr/bin/env bash
# Run: bash tests/ci.test.sh
#
# The CI workflow must exist, run on push and pull_request, run every test in tests/,
# and pin every third-party action to a full commit SHA.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wf="$ROOT/.github/workflows/test.yml"
fail=0
bad() { echo "FAIL $1"; fail=1; }

[[ -f $wf ]] || { bad "$wf does not exist"; exit 1; }

# Parse once with Ruby (preinstalled on macOS and GitHub runners); YAML 1.1 reads the key `on` as true.
report="$(ruby -ryaml -e '
  d = YAML.load_file(ARGV[0])
  on = d["on"] || d[true] || {}
  puts "events=" + (on.is_a?(Hash) ? on.keys : Array(on)).sort.join(",")
  steps = d["jobs"].values.flat_map { |j| j["steps"] || [] }
  puts "run=" + steps.map { |s| s["run"] }.compact.join("\n").gsub("\n", " ; ")
  steps.each { |s| puts "uses=#{s["uses"]}" if s["uses"] }
' "$wf" 2>&1)" || { bad "workflow is not valid YAML: $report"; exit 1; }

grep -q '^events=.*pull_request' <<<"$report" || bad "workflow does not run on pull_request"
grep -q '^events=.*push' <<<"$report" || bad "workflow does not run on push"

runs="$(grep '^run=' <<<"$report")"
for t in "$ROOT"/tests/*.test.*; do
  case "$t" in
    *.test.zsh) grep -q 'tests/\*\.test\.zsh' <<<"$runs" || bad "workflow does not run ${t##*/} (needs a tests/*.test.zsh loop)" ;;
    *.test.sh)  grep -q 'tests/\*\.test\.sh'  <<<"$runs" || bad "workflow does not run ${t##*/} (needs a tests/*.test.sh loop)" ;;
    *) bad "no CI runner for ${t##*/}" ;;
  esac
done

while read -r u; do
  [[ $u =~ @[0-9a-f]{40}$ ]] || bad "action not pinned to a commit SHA: $u"
done < <(grep '^uses=' <<<"$report")

[[ $fail -eq 0 ]] && echo "PASS CI workflow runs every test in tests/ and pins its actions"
exit $fail
