import { randomInt } from 'node:crypto';
import path from 'node:path';
import { setTimeout as sleep } from 'node:timers/promises';

import { loadConfig } from './config.ts';
import { originate } from './contracts.ts';
import { costOf, summarize, type Cost } from './costs.ts';
import { createResultWriter, resultFileName } from './results.ts';
import { createToolkit } from './toolkit.ts';

const SENSOR_ID = 0; // registered in every contract's initial storage

const config = loadConfig();
const tezos = await createToolkit(config);
console.log(`${config.contracts.length} contract(s), ${config.steps} readings each, RPC ${config.rpcUrl}`);

for (const name of config.contracts) {
  const address = await originate(tezos, name);
  const contract = await tezos.contract.at(address);
  const file = path.join(config.resultsDir, resultFileName(name, config.steps, config.intervalMs, new Date()));
  const write = createResultWriter(file);
  const costs: Cost[] = [];
  console.log(`${name} at ${address} -> ${file}`);

  for (let step = 0; step < config.steps; step += 1) {
    const value = randomInt(0, 101);
    const op = await contract.methodsObject.add_data({ sensor_id: SENSOR_ID, data: value }).send();
    await op.confirmation(1);
    const cost = costOf(op.operationResults);
    costs.push(cost);
    write({ step, timestamp: new Date().toISOString(), value, ...cost });
    console.log(`${name} ${step + 1}/${config.steps} value=${value} total=${cost.totalMutez} mutez`);
    if (config.intervalMs > 0) await sleep(config.intervalMs);
  }

  console.table({ [name]: summarize(costs) });
}
