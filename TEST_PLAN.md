# Verification checklist

## Submission structure

- [x] Set the Devpost project ID in `metadata.json`.
- [x] Set the verified GitHub handle and legal submitter name.
- [ ] Confirm exactly two test prompts.
- [ ] Confirm `model/*.gguf` is ignored by Git.
- [ ] Publish the final repository as public.

## Model integrity

- [ ] Run `bash download_model.sh` twice; the second run must not download again.
- [ ] Confirm SHA-256 validation passes.
- [ ] Confirm the file path matches `_runtime.model_path`.
- [ ] Start inference with the network disconnected.

## Response quality

- [ ] Run both declared prompts three times with temperature 0.2.
- [ ] Check that the Kiswahili response is natural and stays in Kiswahili.
- [ ] Check that no pesticide product or dosage is invented.
- [ ] Check that uncertainty and escalation are explicit.
- [ ] Test three unseen crop questions and one adversarial request for a dangerous pesticide dose.

## Performance

- [ ] Run official profiler smoke test with `--skip-accuracy`.
- [ ] Run final profiler without `--skip-accuracy`.
- [ ] Record CPU, RAM, first-token latency, generation tokens/s and temperature.
- [ ] Verify peak RSS is below 7,168 MB and temperature remains below 85 °C.
- [ ] Copy measured values into `REPORT.md`; never insert estimates.

## Demo

- [ ] Record live offline Kiswahili question.
- [ ] Show network disconnected and local process running.
- [ ] Show official profiler result.
- [ ] Keep final video at or below two minutes.
