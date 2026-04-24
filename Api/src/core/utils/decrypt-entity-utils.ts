import { InternalServerErrorException } from "@nestjs/common";
import { EncryptionKeyService } from "src/common/encryption-key/encryption-key.service";
import { aes256GcmDecrypt, decomposeEncryptedData } from "./crypto-utils";

export async function decryptEntityFields<T extends { encryptedKey: string | null }>(
  entity: T,
  field: string,
  encryptionKeyService: EncryptionKeyService,
) : Promise<string> {
  // decrypt KEK
  let plainKEK: string | null;
  try {
    plainKEK = await encryptionKeyService.decryptKEK(entity[field]);
  } catch (err) {
    this.logger.error("Failed to decrypt KEK :", err);
    throw new InternalServerErrorException(
      "Impossible de déchiffrer le Key encryption Key",
    );
  }

  if (!plainKEK) {
    throw new InternalServerErrorException(
      "Impossible de déchiffrer le Key encryption Key",
    );
  }

   // decrypt DEK
    const decomposedDEK = decomposeEncryptedData(entity.encryptedKey!);
    const plainDEK = encryptionKeyService.decryptDEK({
      Dek: decomposedDEK.encrypted as string,
      Kek: plainKEK,
      IV: decomposedDEK.IV,
      tag: decomposedDEK.tag,
    });

    // decrypt field
    const decomposedEncryptedField = decomposeEncryptedData(entity[field]);
    const decryptedField = aes256GcmDecrypt({
      key: plainDEK!,
      encrypted: decomposedEncryptedField.encrypted,
      IV: decomposedEncryptedField.IV,
      tag: decomposedEncryptedField.tag,
    });
	
    return decryptedField;
}
