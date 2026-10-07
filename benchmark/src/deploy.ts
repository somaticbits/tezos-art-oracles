import { loadConfig } from './config.ts';
import { originate } from './contracts.ts';
import { createToolkit } from './toolkit.ts';

const config = loadConfig();
const tezos = await createToolkit(config);

for (const name of config.contracts) {
  console.log(`${name}: ${await originate(tezos, name)}`);
}
