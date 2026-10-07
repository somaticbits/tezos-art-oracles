import { InMemorySigner } from '@taquito/signer';
import { TezosToolkit } from '@taquito/taquito';

import type { Config } from './config.ts';

export const createToolkit = async (config: Config): Promise<TezosToolkit> => {
  const tezos = new TezosToolkit(config.rpcUrl);
  tezos.setProvider({ signer: await InMemorySigner.fromSecretKey(config.secretKey) });
  return tezos;
};
