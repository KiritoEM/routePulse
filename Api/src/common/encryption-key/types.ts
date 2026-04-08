export type GenerateDEKResponse = {
  encryptedDEK: string;
  plainDEK: string;
};

export type GenerateKEKResponse = {
  plainKEK: string;
};

export type DescryptDEKSchema = {
  IV: string;
  tag: string;
  Kek: string;
  Dek: string;
};
