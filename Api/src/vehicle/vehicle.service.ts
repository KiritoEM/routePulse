import {
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { UserRepository } from "src/user/user.repository";
import { VehicleRepository } from "./vehicle.repository";
import { CreateVehicleSchema } from "./types";
import { Vehicle } from "src/common/drizzle/schemas";

@Injectable()
export class VehicleService {
  constructor(
    private vehicleRepository: VehicleRepository,
    private userRepository: UserRepository,
  ) {}

  async createVehicle(
    userId: string,
    data: Omit<CreateVehicleSchema, "userId">,
  ) {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
    }

     await this.vehicleRepository.create({
      ...data,
      userId,
    });
  }

  async findAllVehicles(userId: string): Promise<Vehicle[]> {
    return await this.vehicleRepository.findAll(userId);
  } 
}
