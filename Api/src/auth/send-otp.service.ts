import {
  Injectable,
  InternalServerErrorException,
  Logger,
} from "@nestjs/common";
import { MailService } from "src/common/mail/mail.service";
import { RegisterEmailParams } from "./types";
import path from "path";

@Injectable()
export class SendOtpService {
  private readonly logger = new Logger(SendOtpService.name);

  private readonly commonAttachments: Record<string, string | any>[] = [
    {
      filename: "emanasa-logo.png",
      path: path.join(
        process.cwd(),
        "src/common/mail/static/routepulse-logo.png",
      ),
      cid: "logo@routepulse",
    },
  ];

  constructor(private mailService: MailService) {}

  // send register email utility
  async sendRegisterEmail(data: RegisterEmailParams) {
    try {
      await this.mailService.sendEmail({
        subject: "Confirmation de la création de votre compte RoutePulse",
        to: data.email,
        template: "register-otp",
        context: {
          otpCode: data.otpCode,
          expirationMinutes: 5,
          name:
            data.name.split(" ").length > 0
              ? data.name.split(" ")[0]
              : data.name,
        },
        attachments: [...this.commonAttachments],
      });
    } catch (err) {
      this.logger.error("Failed to send OTP to user: ", err);
      throw new InternalServerErrorException(
        "Impossible d'envoyer le code de vérification à votre adresse email",
      );
    }
  }

  // send reset password email utility
  async sendResetPasswordEmail(data: RegisterEmailParams) {
    try {
      await this.mailService.sendEmail({
        subject: "Réinitialisation du mot de passe de votre compte RoutePulse",
        to: data.email,
        template: "reset-password-otp",
        context: {
          otpCode: data.otpCode,
          expirationMinutes: 5,
          name:
            data.name.split(" ").length > 0
              ? data.name.split(" ")[0]
              : data.name,
        },
        attachments: [...this.commonAttachments],
      });
    } catch (err) {
      this.logger.error("Failed to send OTP to user: ", err);
      throw new InternalServerErrorException(
        "Impossible d'envoyer le code de vérification à votre adresse email",
      );
    }
  }
}
