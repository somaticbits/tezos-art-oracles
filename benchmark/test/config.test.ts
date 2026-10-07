import assert from 'node:assert/strict';
import { test } from 'node:test';

import { CONTRACT_NAMES, SANDBOX_ALICE_SECRET_KEY, loadConfig } from '../src/config.ts';

test('defaults target the local sandbox with all contracts', () => {
  assert.deepEqual(loadConfig({}), {
    rpcUrl: 'http://localhost:20000',
    secretKey: SANDBOX_ALICE_SECRET_KEY,
    steps: 2880,
    intervalMs: 0,
    contracts: [...CONTRACT_NAMES],
    resultsDir: 'results',
  });
});

test('reads overrides from the environment', () => {
  const config = loadConfig({ STEPS: '10', INTERVAL_MS: '500', CONTRACTS: 'oracle_map, oracle_bigmap' });
  assert.equal(config.steps, 10);
  assert.equal(config.intervalMs, 500);
  assert.deepEqual(config.contracts, ['oracle_map', 'oracle_bigmap']);
});

test('rejects bad numbers and unknown contracts', () => {
  assert.throws(() => loadConfig({ STEPS: '-1' }), /STEPS/);
  assert.throws(() => loadConfig({ INTERVAL_MS: 'soon' }), /INTERVAL_MS/);
  assert.throws(() => loadConfig({ CONTRACTS: 'oracle_list' }), /oracle_list/);
});
