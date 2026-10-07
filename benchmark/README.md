# benchmark

Deploys the three oracle contracts from [`../contracts`](../contracts) to a local Flextesa sandbox, calls `add_data` with a random value from 0 to 100 every `intervalTime` ms for `intervalSteps` steps, and writes the fees for each call to one CSV per contract in `src/results/`.

```bash
npm install
npm run dev
```

Compile the contracts and start the sandbox first; see [Run it](../README.md#run-it). Settings are in `src/config.ts`. The defaults (4,000 ms, 2,880 steps) take about 3 hours per contract.

CSV columns: `timestamp`, `data`, `consumedGas`, `storageFee`, `total`.

`NOTES.md` has setup notes for running on a Raspberry Pi with a physical sensor (pigpio).
