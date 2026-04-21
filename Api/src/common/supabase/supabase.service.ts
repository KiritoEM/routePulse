import { BadRequestException, Inject, Injectable } from "@nestjs/common";
import { SupabaseClient } from "@supabase/supabase-js";
import { UploadFileResponse, uploadFileSchema } from "./types";
import { SUPABASE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class SupabaseService {
  private imageBucket: string = "images";

  constructor(
    @Inject(SUPABASE_PROVIDER_KEY) private readonly supabase: SupabaseClient,
  ) {}

  // upload file to supabase storage
  async uploadFile(data: uploadFileSchema): Promise<UploadFileResponse> {
    const { data: resultData, error } = await this.supabase.storage
      .from(this.imageBucket)
      .upload(data.originalFileName, data.file, {
        contentType: data.fileMimetype,
        upsert: false,
        cacheControl: "3600",
      });

    if (error) throw new BadRequestException(error.message);

    return {
      path: resultData.path,
      fullPath: resultData.fullPath,
    };
  }

  // create signed URL for file access
  async createSignedURL(
    bucketPath: string,
    expiresIn: number,
  ): Promise<string> {
    const { data, error } = await this.supabase.storage
      .from(this.imageBucket)
      .createSignedUrl(bucketPath, expiresIn);

    if (error) throw new BadRequestException(error.message);

    return data.signedUrl;
  }

  // download image from the private bucket
  async downloadFile(fileMimeType: string, bucketPath: string): Promise<Blob> {
    const { data, error } = await this.supabase.storage
      .from(this.imageBucket)
      .download(bucketPath);

    if (error) throw new BadRequestException(error.message);

    return data;
  }
}
