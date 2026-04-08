import { randomInt } from "crypto";

type GenerateRandomNumberSchema = {
  length?: number;
  pattern: string;
};

export const generateRandomDigitalNumber = (
  params?: GenerateRandomNumberSchema,
): string => {
  const length = params?.length ?? 6;
  const pattern = params?.pattern ?? "0123456789";

  let otp = "";
  for (let i = 0; i < length; i++) {
    otp += pattern[randomInt(0, pattern.length)];
  }
  return otp;
};
