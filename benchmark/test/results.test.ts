import assert from 'node:assert/strict';
import { mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { test } from 'node:test';

import { createResultWriter, resultFileName } from '../src/results.ts';

test('result file names sort by start time and describe the run', () => {
  const startedAt = new Date('2022-05-17T13:04:09.123Z');
  assert.equal(resultFileName('oracle_map', 2880, 0, startedAt), '2022-05-17T13-04-09-oracle_map-2880x0ms.csv');
});

test('the writer appends one CSV row per sample after the header', () => {
  const file = path.join(mkdtempSync(path.join(tmpdir(), 'otf-')), 'nested', 'run.csv');
  const write = createResultWriter(file);
  const cost = {
    feeMutez: 362,
    consumedMilligas: 1,
    storageDiffBytes: 67,
    storageBurnMutez: 16_750,
    totalMutez: 17_112,
  };
  write({ step: 0, timestamp: '2022-05-17T13:04:09.123Z', value: 42, ...cost });

  assert.equal(
    readFileSync(file, 'utf8'),
    'step,timestamp,value,feeMutez,consumedMilligas,storageDiffBytes,storageBurnMutez,totalMutez\n' +
      '0,2022-05-17T13:04:09.123Z,42,362,1,67,16750,17112\n',
  );
});
