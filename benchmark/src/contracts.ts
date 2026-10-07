import type { TezosToolkit } from '@taquito/taquito';
import { readFileSync } from 'node:fs';

import type { ContractName } from './config.ts';

const contractsDir = new URL('../../contracts/', import.meta.url);

export const readContract = (name: ContractName) => ({
  code: readFileSync(new URL(`${name}/contracts/main.tz`, contractsDir), 'utf8'),
  init: readFileSync(new URL(`${name}/contracts/main_storage.tz`, contractsDir), 'utf8'),
});

export const originate = async (tezos: TezosToolkit, name: ContractName): Promise<string> => {
  const op = await tezos.contract.originate(readContract(name));
  console.log(`Originating ${name} (${op.hash})`);
  await op.confirmation(1);
  if (!op.contractAddress) throw new Error(`Origination of ${name} returned no address`);
  return op.contractAddress;
};
