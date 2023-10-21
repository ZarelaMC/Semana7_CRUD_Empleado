package com.empresa.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.empresa.entity.Empleado;

public interface EmpleadoRepository extends JpaRepository<Empleado, Integer> {
	//Para crear VALIDACIONES
	@Query("select e from Empleado e where e.nombres =?1 and e.apellidos = ?2")
	public List<Empleado> listarNombreApellidoIgual(String nombre, String apellido);
	
	@Query("select e from Empleado e where e.nombres like ?1 or e.apellidos like ?1")
	public List<Empleado> listarNombreApellidoLike(String filtro);
}
