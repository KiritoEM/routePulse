import { MulterFile } from 'src/types/multer';

export type uploadFileSchema = {
  file: Buffer;
  fileMimetype: string;
  originalFileName: MulterFile['originalname'];
};

export type UploadFileResponse = {
  path: string;
  fullPath: string;
};
