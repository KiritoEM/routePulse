import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import { JwtUtilsService } from "src/common/jwt-utils/jwt-utils.service";
import { IBaseJWTPayload } from "../types";

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtUtilsService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request: Request = context.switchToHttp().getRequest();
    const header = request.headers["authorization"] as string;

    if (!header) {
      throw new UnauthorizedException("Header Bearer invalide");
    }

    const token = header.split(" ")[1];

    if (!token) {
      throw new UnauthorizedException("Pas de token fournis");
    }

    const payload = (await this.jwtService.verifyToken(
      token,
    )) as IBaseJWTPayload;

    if (!payload) {
      throw new UnauthorizedException("Le token n'a pas de payload valide");
    }

    request["user"] = payload;

    return true;
  }
}
