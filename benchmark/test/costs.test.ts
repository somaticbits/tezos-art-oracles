import type { OperationContentsAndResultTransaction } from '@taquito/rpc';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

import { costOf, summarize } from '../src/costs.ts';

// Receipt of a real add_data call to oracle_bigmap on a Flextesa Oxford sandbox.
const receipt: OperationContentsAndResultTransaction[] = JSON.parse(
  readFileSync(new URL('fixtures/bigmap-add-data.json', import.meta.url), 'utf8'),
);

test('costOf reads fee, gas and storage burn from a receipt', () => {
  assert.deepEqual(costOf(receipt), {
    feeMutez: 362,
    consumedMilligas: 611_187,
    storageDiffBytes: 67,
    storageBurnMutez: 16_750,
    totalMutez: 17_112,
  });
});

test('costOf does not add gas to the tez total', () => {
  const { totalMutez, feeMutez, storageBurnMutez } = costOf(receipt);
  assert.equal(totalMutez, feeMutez + storageBurnMutez);
});

test('costOf rejects operations that were not applied', () => {
  const failed = structuredClone(receipt);
  failed[0].metadata.operation_result.status = 'backtracked';
  assert.throws(() => costOf(failed), /backtracked/);
});

test('summarize averages per call and totals in tez', () => {
  const call = { feeMutez: 400, consumedMilligas: 0, storageDiffBytes: 0, storageBurnMutez: 0, totalMutez: 400 };
  const summary = summarize([call, { ...call, storageBurnMutez: 1000, totalMutez: 1400 }]);
  assert.deepEqual(summary, {
    samples: 2,
    meanFeeMutez: 400,
    meanStorageBurnMutez: 500,
    meanTotalMutez: 900,
    totalTez: 0.0018,
  });
});

test('summarize handles an empty run', () => {
  assert.equal(summarize([]).meanTotalMutez, 0);
});
