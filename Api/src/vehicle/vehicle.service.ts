import {
  ConflictException,
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from "@nestjs/common";
import { UserRepository } from "src/user/user.repository";
import { VehicleRepository } from "./vehicle.repository";
import { CreateVehicleSchema, UpdateVehicleSchema } from "./types";
import { Vehicle } from "src/common/drizzle/schemas";

const FOREIGN_KEY_VIOLATION_CODE = "23503";

@Injectable()
export class VehicleService {
  private readonly logger = new Logger(VehicleService.name);

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

  async findAllVehicles(userId: string, isActive?: boolean): Promise<Vehicle[]> {
    return await this.vehicleRepository.findAll(userId, isActive);
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

  async toggleVehicleStatus(
    userId: string,
    vehicleId: string,
    isActive: boolean,
  ): Promise<Vehicle | null> {
    const vehicle = await this.vehicleRepository.findById(vehicleId);

    if (!vehicle || vehicle.userId !== userId) {
      throw new NotFoundException("Le véhicule est introuvable");
    }

    return await this.vehicleRepository.updateStatus(vehicleId, isActive);
  }

  async deleteVehicle(userId: string, vehicleId: string): Promise<void> {
    const vehicle = await this.vehicleRepository.findById(vehicleId);

    if (!vehicle || vehicle.userId !== userId) {
      throw new NotFoundException("Le véhicule est introuvable");
    }

    try {
      await this.vehicleRepository.delete(vehicleId);
    } catch (err) {
      // vehicle still referenced by deliveries
      if (err?.code === FOREIGN_KEY_VIOLATION_CODE) {
        throw new ConflictException(
          "Ce véhicule est utilisé par des livraisons. Désactivez-le au lieu de le supprimer",
        );
      }

      this.logger.error("Failed to delete vehicle: ", err);
      throw new InternalServerErrorException(
        "Impossible de supprimer le véhicule",
      );
    }
  }
}
