import { stringify } from 'csv-stringify/sync';
import { appendFileSync, mkdirSync } from 'node:fs';
import path from 'node:path';

import type { Cost } from './costs.ts';

export type Sample = Cost & {
  step: number;
  timestamp: string;
  /** The fake sensor reading that was stored. */
  value: number;
};

const COLUMNS: (keyof Sample)[] = [
  'step',
  'timestamp',
  'value',
  'feeMutez',
  'consumedMilligas',
  'storageDiffBytes',
  'storageBurnMutez',
  'totalMutez',
];

export const resultFileName = (contract: string, steps: number, intervalMs: number, startedAt: Date): string => {
  const stamp = startedAt.toISOString().slice(0, 19).replaceAll(':', '-');
  return `${stamp}-${contract}-${steps}x${intervalMs}ms.csv`;
};

/** Writes the header now and one row per sample, so an interrupted run keeps what it measured. */
export const createResultWriter = (filePath: string) => {
  mkdirSync(path.dirname(filePath), { recursive: true });
  appendFileSync(filePath, stringify([COLUMNS]));
  return (sample: Sample) => appendFileSync(filePath, stringify([sample], { columns: COLUMNS }));
};
