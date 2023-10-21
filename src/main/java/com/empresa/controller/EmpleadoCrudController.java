package com.empresa.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.empresa.entity.Empleado;
import com.empresa.service.EmpleadoService;
import com.empresa.util.FunctionUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class EmpleadoCrudController {
	@Autowired
	private EmpleadoService empleadoService;
	
	//Cargar el .jsp
	@GetMapping(value = "/verCrudEmpleado") /*RUTA*/
	public String verEmpleado()  {return "crudEmpleado";} /*nombre del .JSP*/
	
	@GetMapping(value = "/consultaCrudEmpleado") 
	@ResponseBody //RESPUESTA DE CUERPO DE TIPO .JSON
	public List<Empleado> consulta(String filtro)  {
		return empleadoService.listaPorNombreApellidoLike("%" + filtro + "%");  /*Mètodo*/
	}
	
	@ResponseBody
	@GetMapping("/buscaEmpleadoMayorEdad")
	public String busca(String fechaNacimiento){
		if(FunctionUtil.isMayorEdad(fechaNacimiento)) {  /*Mètodo implemenado por el profesor en el FunctionUtil del package com.empresa.util*/
			return "{\"valid\":true}";
		} else {  
			return "{\"valid\":false}";
		}
	}
	
	@PostMapping("/registraCrudEmpleado")
	@ResponseBody
	public Map<?, ?> registra(Empleado obj) {
		HashMap<String, Object> map = new HashMap<String, Object>(); /*Permite colocar los mensajes*/
		obj.setEstado(1);
		//Datos que se llenarán por defecto, automáticamente
		obj.setFechaRegistro(new Date()); //Toma la fecha del sistema
		obj.setFechaActualizacion(new Date()); //Toma la fecha del sistema
		
		List<Empleado> lstSalida = empleadoService.
				//VALIDACIÒN PARA IMPEDIR QUE SE REGISTRE UN EMPLEADO CUYO NOMBRE Y APELLIDOS EN CONJUNO YA EXISTAN
						listaPorNombreApellidoIgual(obj.getNombres(), obj.getApellidos());
		if (!CollectionUtils.isEmpty(lstSalida)) { //Si la lista es vacía, no trae datos coincidentes, 
			map.put("mensaje", "El empleado " + obj.getNombres() + " " + obj.getApellidos() + " ya existe");
			return map;
		}
		
		Empleado objSalida = empleadoService.insertaEmpleado(obj);
		if (objSalida == null) {
			map.put("mensaje", "Error en el registro");
		} else {
			//Actualizar la Grilla en el navegador al hacer un registro
			List<Empleado> lista = empleadoService.listaPorNombreApellidoLike("%");
			map.put("lista", lista);
			//Mostrar mensaje de confirmación
			map.put("mensaje", "Registro exitoso");
		}
		return map;
	}
	
	//ACTUALIZAR  ----------------------------------------------
	@PostMapping("/actualizaCrudEmpleado")
	@ResponseBody
	public Map<?, ?> actualiza(Empleado obj, HttpSession session) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Optional<Empleado> optEmpleado= empleadoService.buscaEmpleado(obj.getIdEmpleado());
		
		//Validaciones por nombre y apellido
		List<Empleado> lstSalida = empleadoService.listaPorNombreApellidoIgualActualiza(obj.getNombres(), obj.getApellidos(), optEmpleado.get().getIdEmpleado());
		if (!CollectionUtils.isEmpty(lstSalida)) {
			map.put("mensaje", "El empleado " + obj.getNombres()+ " " + obj.getApellidos() + " ya existe");
			List<Empleado> lista = empleadoService.listaPorNombreApellidoLike("%");
			map.put("lista", lista);
			return map;
		}
				
		obj.setFechaRegistro(optEmpleado.get().getFechaRegistro());
		obj.setEstado(optEmpleado.get().getEstado());
		obj.setFechaActualizacion(new Date());
		
		Empleado objSalida = empleadoService.actualizaEmpleado(obj);
		if (objSalida == null) {
			map.put("mensaje", "Error en actualizar");
		} else {
			map.put("mensaje", "Actualización exitosa");
			List<Empleado> lista = empleadoService.listaPorNombreApellidoLike("%");
			map.put("lista", lista);
		}
		return map;
	}
	
	
	//ELIMINAR ----------------------------------------------
	@ResponseBody
	@PostMapping("/eliminaCrudEmpleado")
	public Map<?, ?> elimina(int id) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		Empleado objEmpleado= empleadoService.buscaEmpleado(id).get();
		objEmpleado.setFechaActualizacion(new Date());  
		objEmpleado.setEstado( objEmpleado.getEstado() == 1 ? 0 : 1);
		Empleado objSalida = empleadoService.actualizaEmpleado(objEmpleado);
		if (objSalida == null) {
			map.put("mensaje", "Error en actualizar");
		} else {
			List<Empleado> lista = empleadoService.listaPorNombreApellidoLike("%");
			map.put("lista", lista);
		}
		return map;
	}
}
