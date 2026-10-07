import type { OperationBalanceUpdates, OperationContentsAndResultTransaction } from '@taquito/rpc';

export type Cost = {
  /** Baker fee paid by the sender, in mutez. */
  feeMutez: number;
  consumedMilligas: number;
  /** New bytes of contract storage paid for by this call. */
  storageDiffBytes: number;
  /** Tez burned to pay for that storage, in mutez. */
  storageBurnMutez: number;
  /** What the call cost the sender: fee + storage burn, in mutez. */
  totalMutez: number;
};

const storageBurn = (updates: OperationBalanceUpdates | undefined): number =>
  (updates ?? [])
    .filter((update) => update.kind === 'burned' && update.category === 'storage fees')
    .reduce((sum, update) => sum + Number(update.change), 0);

/** Sums what a confirmed contract call cost, from the receipts the node returned. */
export const costOf = (results: OperationContentsAndResultTransaction[]): Cost => {
  let feeMutez = 0;
  let consumedMilligas = 0;
  let storageDiffBytes = 0;
  let storageBurnMutez = 0;

  for (const content of results) {
    const result = content.metadata.operation_result;
    if (result.status !== 'applied') {
      throw new Error(`Operation ${result.status}: ${JSON.stringify(result.errors ?? [])}`);
    }
    feeMutez += Number(content.fee);
    consumedMilligas += Number(result.consumed_milligas ?? 0);
    storageDiffBytes += Number(result.paid_storage_size_diff ?? 0);
    storageBurnMutez += storageBurn(result.balance_updates);
    for (const internal of content.metadata.internal_operation_results ?? []) {
      storageBurnMutez += storageBurn(
        (internal.result as { balance_updates?: OperationBalanceUpdates }).balance_updates,
      );
    }
  }

  return {
    feeMutez,
    consumedMilligas,
    storageDiffBytes,
    storageBurnMutez,
    totalMutez: feeMutez + storageBurnMutez,
  };
};

export type Summary = {
  samples: number;
  meanFeeMutez: number;
  meanStorageBurnMutez: number;
  meanTotalMutez: number;
  totalTez: number;
};

export const summarize = (costs: Cost[]): Summary => {
  const sum = (pick: (cost: Cost) => number) => costs.reduce((total, cost) => total + pick(cost), 0);
  const mean = (pick: (cost: Cost) => number) => (costs.length === 0 ? 0 : sum(pick) / costs.length);
  return {
    samples: costs.length,
    meanFeeMutez: mean((cost) => cost.feeMutez),
    meanStorageBurnMutez: mean((cost) => cost.storageBurnMutez),
    meanTotalMutez: mean((cost) => cost.totalMutez),
    totalTez: sum((cost) => cost.totalMutez) / 1e6,
  };
};
