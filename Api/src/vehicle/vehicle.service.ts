import { Injectable, NotFoundException } from "@nestjs/common";
import { UserRepository } from "src/user/user.repository";
import { VehicleRepository } from "./vehicle.repository";
import { CreateVehicleSchema, UpdateVehicleSchema } from "./types";
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
  ): Promise<Vehicle | null> {
    const user = await this.userRepository.findById(userId);
    if (!user) {
      throw new NotFoundException("L'utilisateur est introuvable");
    }

    const createdVehicle = await this.vehicleRepository.create({
      ...data,
      userId,
    });

    if (!createdVehicle) {
      return null;
    }

    return createdVehicle;
  }

  async findAllVehicles(userId: string): Promise<Vehicle[]> {
    return await this.vehicleRepository.findAll(userId);
  }

  async updateVehicle(
    userId: string,
    vehicleId: string,
    data: UpdateVehicleSchema,
  ): Promise<Vehicle | null> {
    const vehicle = await this.vehicleRepository.findById(vehicleId);
    if (!vehicle) {
      throw new NotFoundException("Le véhicule est introuvable");
    }

    if (vehicle.userId !== userId) {
      throw new NotFoundException("Le véhicule est introuvable");
    }

    return await this.vehicleRepository.update(vehicleId, data);
  }
}
