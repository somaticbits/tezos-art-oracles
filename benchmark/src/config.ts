export const CONTRACT_NAMES = ['oracle_map', 'oracle_bigmap', 'oracle_record_bigmap'] as const;
export type ContractName = (typeof CONTRACT_NAMES)[number];

// Well-known secret key of the "alice" bootstrap account in the Flextesa sandbox.
// It is public and only valid on a local sandbox; never use it on a real network.
export const SANDBOX_ALICE_SECRET_KEY = 'edsk3QoqBuvdamxouPhin7swCvkQNgq4jP5KZPbwWNnwdZpSpJiEbq';

export type Config = {
  rpcUrl: string;
  secretKey: string;
  /** Readings written per contract. 2880 is one day at one reading every 30 s. */
  steps: number;
  /** Extra pause between readings, on top of waiting for each one to be included in a block. */
  intervalMs: number;
  contracts: ContractName[];
  resultsDir: string;
};

const nonNegativeInt = (name: string, raw: string | undefined, fallback: number): number => {
  if (raw === undefined || raw === '') return fallback;
  const value = Number(raw);
  if (!Number.isInteger(value) || value < 0) throw new Error(`${name} must be a non-negative integer, got "${raw}"`);
  return value;
};

const contractList = (raw: string | undefined): ContractName[] => {
  if (raw === undefined || raw === '') return [...CONTRACT_NAMES];
  return raw.split(',').map((name) => {
    const trimmed = name.trim();
    if (!(CONTRACT_NAMES as readonly string[]).includes(trimmed)) {
      throw new Error(`Unknown contract "${trimmed}" in CONTRACTS; expected one of ${CONTRACT_NAMES.join(', ')}`);
    }
    return trimmed as ContractName;
  });
};

export const loadConfig = (env: NodeJS.ProcessEnv = process.env): Config => ({
  rpcUrl: env.TEZOS_RPC_URL || 'http://localhost:20000',
  secretKey: env.TEZOS_SECRET_KEY || SANDBOX_ALICE_SECRET_KEY,
  steps: nonNegativeInt('STEPS', env.STEPS, 2880),
  intervalMs: nonNegativeInt('INTERVAL_MS', env.INTERVAL_MS, 0),
  contracts: contractList(env.CONTRACTS),
  resultsDir: env.RESULTS_DIR || 'results',
});
