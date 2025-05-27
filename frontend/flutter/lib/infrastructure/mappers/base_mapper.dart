/// Base mapper interface for converting between DTOs and domain entities
abstract class BaseMapper<DTO, Entity> {
  /// Converts a DTO to a domain entity
  Entity toEntity(DTO dto);
  
  /// Converts a domain entity to a DTO
  DTO toDto(Entity entity);
  
  /// Converts a list of DTOs to a list of entities
  List<Entity> toEntityList(List<DTO> dtos) {
    return dtos.map((dto) => toEntity(dto)).toList();
  }
  
  /// Converts a list of entities to a list of DTOs
  List<DTO> toDtoList(List<Entity> entities) {
    return entities.map((entity) => toDto(entity)).toList();
  }
  
  /// Converts a nullable DTO to a nullable entity
  Entity? toEntityOrNull(DTO? dto) {
    return dto != null ? toEntity(dto) : null;
  }
  
  /// Converts a nullable entity to a nullable DTO
  DTO? toDtoOrNull(Entity? entity) {
    return entity != null ? toDto(entity) : null;
  }
}