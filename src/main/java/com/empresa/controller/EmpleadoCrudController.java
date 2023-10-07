package com.empresa.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.empresa.entity.Empleado;
import com.empresa.service.EmpleadoService;
import com.empresa.util.FunctionUtil;

@Controller
public class EmpleadoCrudController {
	@Autowired
	private EmpleadoService empleadoService;
	
	//Cargar el .jsp
	@GetMapping(value = "/verCrudEmpleado") /*RUTA*/
	public String verEmpleado()  {return "crudEmpleado2";} /*nombre del .JSP*/
	
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
		HashMap<String, Object> map = new HashMap<String, Object>();
		obj.setEstado(1);
		obj.setFechaRegistro(new Date());
		obj.setFechaActualizacion(new Date());
		
		List<Empleado> lstSalida = empleadoService.
				//VALIDACIÒN PARA IMPEDIR QUE SE REGISTRE UN EMPLEADO CUYO NOMBRE Y APELLIDOS EN CONJUNO YA EXISTAN
						listaPorNombreApellidoIgual(
								obj.getNombres(), 
								obj.getApellidos());
		if (!CollectionUtils.isEmpty(lstSalida)) {
			map.put("mensaje", "El empleado " + obj.getNombres() + " " + obj.getApellidos() + " ya existe");
			return map;
		}
		
		Empleado objSalida = empleadoService.insertaEmpleado(obj);
		if (objSalida == null) {
			map.put("mensaje", "Error en el registro");
		} else {
			List<Empleado> lista = empleadoService.listaPorNombreApellidoLike("%");
			map.put("lista", lista);
			map.put("mensaje", "Registro exitoso");
		}
		return map;
	}
}
