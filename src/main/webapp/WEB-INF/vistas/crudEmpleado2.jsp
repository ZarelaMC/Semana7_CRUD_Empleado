<!DOCTYPE html>
<html lang="esS" >
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="js/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript" src="js/bootstrapValidator.js"></script>
<script type="text/javascript" src="js/global.js"></script>

<link rel="stylesheet" href="css/bootstrap.css"/>
<link rel="stylesheet" href="css/dataTables.bootstrap.min.css"/>
<link rel="stylesheet" href="css/bootstrapValidator.css"/>
<title>Ejemplos de CIBERTEC - Jorge Jacinto </title>
</head>
<body>
 <div class="container">  
 <h3>Crud de Empleado</h3>
 
 <div class="row" >  
 			<!--------------------------------------- PANEL Cabecera ----------------------------------------------->
		   <div class="row" style="height: 70px">
				<div class="col-md-2" >
						<input class="form-control" id="id_txt_filtro"  name="filtro" placeholder="Ingrese el nombre" type="text" maxlength="30"/>
				</div>
				<div class="col-md-2" >
					<button type="button" class="btn btn-primary" id="id_btn_filtrar" style="width: 150px">FILTRA</button>
				</div>
				<div class="col-md-2">
					<button type="button" data-toggle='modal'  data-target="#id_div_modal_registra"  class='btn btn-success' style="width: 150px">REGISTRA</button>
				</div>
			</div>
			<!--------------------------------------- GRILLA - Tabla ----------------------------------------------->
			<div class="row" > 
				<div class="col-md-12">
						<div class="content" >
							<table id="id_table" class="table table-striped table-bordered" >
								<thead>
									<tr>
										<th style="width: 5%">Código</th>
										<th style="width: 20%">Nombres</th>
										<th style="width: 20%">Apellidos</th>
										<th style="width: 15%">Fecha de Nacimiento</th>
										<th style="width: 20%">País</th>
										<th style="width: 10%">Actualiza</th>
										<th style="width: 10%">Elimina</th>
									</tr>
								</thead>
								</table>
						</div>	
				</div>
			</div>
</div>
</div>
<!--------------------------------------- MODAL de registro ----------------------------------------------->
  	 <div class="modal fade" id="id_div_modal_registra" >
			<div class="modal-dialog" style="width: 60%">
					<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header" style="padding: 35px 50px">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4><span class="glyphicon glyphicon-ok-sign"></span> Registro de modalidad</h4>
					</div>
					<div class="modal-body" style="padding: 20px 10px;">
							<form id="id_form_registra" accept-charset="UTF-8" action="registraActualizaCrudModalidad" class="form-horizontal"  method="post">
			                    <div class="panel-group" id="steps">
			                        <!-- Step 1 -->
			                        <div class="panel panel-default">
			                            <div class="panel-heading">
			                                <h4 class="panel-title"><a data-toggle="collapse" data-parent="#steps" href="#stepOne">Datos de Modalidad</a></h4>
			                            </div>
			                            <div id="stepOne" class="panel-collapse collapse in">
			                                <div class="panel-body">
			                                     <div class="form-group">
			                                        <label class="col-lg-3 control-label" for="id_reg_nombres">Nombres</label>
			                                        <div class="col-lg-8">
														<input class="form-control" id="id_reg_nombres" name="nombres" placeholder="Ingrese el nombre" type="text" maxlength="40"/>
			                                        </div>
			                                    </div>
			                                    <div class="form-group">
			                                        <label class="col-lg-3 control-label" for="id_reg_apellidos">Apellidos</label>
			                                        <div class="col-lg-3">
														<input class="form-control" id="id_reg_apellidos" name="apellidos" placeholder="Ingrese el apellidos" type="text" maxlength="40"/>
			                                        </div>
			                                    </div>
			                                    <div class="form-group">
			                                        <label class="col-lg-3 control-label" for="id_reg_fecha_nacimiento">Fecha de nacimiento</label>
			                                        <div class="col-lg-3">
														<input class="form-control" id="id_reg_fecha_nacimiento" name="fechaNacimiento" type="date"/>
			                                        </div>
			                                    </div>		   
			                                    <div class="form-group">
			                                        <label class="col-lg-3 control-label" for="id_reg_pais">País</label>
			                                        <div class="col-lg-3">
														 <select id="id_reg_pais" name="pais" class='form-control'>
								                            	<option value=" ">[Seleccione]</option>    
								                         </select>
			                                        </div>
			                                    </div>
			                                    <div class="form-group">
			                                        <div class="col-lg-9 col-lg-offset-3">
			                                        	<button type="button" class="btn btn-primary" id="id_btn_registra">REGISTRA</button>
			                                        </div>
			                                    </div>
			                                </div>
			                            </div>
			                        </div>
			                    </div>
			                </form>   
					
					</div>
				</div>
			</div>
		</div>
</body>

<script type="text/javascript">
//------------------------ LISTAR paises en el CBO ---------------------------------------------
//-- Mostrar la lista de Países en el cbo --Viene del PaisService y PaisServiceImpl ----------
$.getJSON("listaPais", {}, function(data){
	$.each(data, function(i,item){
		$("#id_reg_pais").append("<option value="+item.idPais +">"+ item.nombre +"</option>");
	});
});
//------------------------ Mostrar lista de registros en GRILLA ---------------------------
//---- Al cargar el documento, mostrar las filas en la grilla, esto se logra pasando un valor vacío al parámetro "filtro" del Controller -----------
$(document).ready(function() {
	$.getJSON("consultaCrudEmpleado",{"filtro":""}, function (lista){
		agregarGrilla(lista);
	});
});
//---------------------------------- Botón FILTRA ------------------------------------------
//----- Al dar click en el botón FILTRA, crear variable "fil" que recoja el valor de la caja de texto, luego llamar al método "consultaCrudEmpleado" del Controller
//y pasarle por parámetro la variable, luego agregarlo a la grilla
$("#id_btn_filtrar").click(function(){
	var fil=$("#id_txt_filtro").val();
	$.getJSON("consultaCrudEmpleado",{"filtro":fil}, function (lista){
		agregarGrilla(lista);
	});
});


//---------------------------------- Método para agregar una fila a la grilla  ------------------------------------------
function agregarGrilla(lista){
	 $('#id_table').DataTable().clear(); //Limpiar tabla
	 $('#id_table').DataTable().destroy(); //Destruye la instancia anterior de la tabla
	 $('#id_table').DataTable({ //Crea una nueva instancia de la tabla,
			data: lista,
			searching: false,
			ordering: true,
			processing: true,
			pageLength: 5,
			lengthChange: false,
			columns:[
				{data: "idEmpleado"},
				{data: "nombres"},
				{data: "apellidos"},
				{data: "fechaNacimiento"},
				{data: "pais.nombre"},
				{data: function(row, type, val, meta){
					var salida='<button type="button" style="width: 90px" class="btn btn-info btn-sm" onclick="editar(\''+row.idEmpleado + '\',\'' + row.nombres +'\',\'' + row.apellidos  +'\',\'' + row.fechaNacimiento + '\',\'' + row.pais.idPais + '\')">Editar</button>';
					return salida;
				},className:'text-center'},	
				{data: function(row, type, val, meta){
				    var salida='<button type="button" style="width: 90px" class="btn btn-warning btn-sm" onclick="accionEliminar(\'' + row.idEmpleado + '\')">'+ (row.estado == 1? 'Activo':'Inactvo') +  '</button>';
					return salida;
				},className:'text-center'},													
			]                                     
	    });
}

//--------------------- Botón REGISTRA del modal de registro ---------------------
$("#id_btn_registra").click(function(){
	var validator = $('#id_form_registra').data('bootstrapValidator');
    validator.validate();
	
    if (validator.isValid()) {
        $.ajax({
          type: "POST",
          url: "registraCrudEmpleado", 
          data: $('#id_form_registra').serialize(),
          success: function(data){
        	  agregarGrilla(data.lista);
        	  $('#id_div_modal_registra').modal("hide");
        	  mostrarMensaje(data.mensaje);
        	  limpiarFormulario();
        	  validator.resetForm();
          },
          error: function(){
        	  mostrarMensaje(MSG_ERROR);
          }
        });
        
    }
});

function limpiarFormulario(){	
	$('#id_reg_nombres').val('');
	$('#id_reg_apellidos').val('');
	$('#id_reg_fecha_nacimiento').val('');
	$('#id_reg_pais').val(' ');
}

$('#id_form_registra').bootstrapValidator({
    message: 'This value is not valid',
    feedbackIcons: {
        valid: 'glyphicon glyphicon-ok',
        invalid: 'glyphicon glyphicon-remove',
        validating: 'glyphicon glyphicon-refresh'
    },
    fields: {
    	"nombres": {
    		selector : '#id_reg_nombres',
            validators: {
                notEmpty: {
                    message: 'El nombre es un campo obligatorio'
                },
                stringLength :{
                	message:'El nombre es de 3 a 100 caracteres',
                	min : 3,
                	max : 100
                }
            }
        },
        "apellidos": {
    		selector : '#id_reg_apellidos',
            validators: {
                notEmpty: {
                    message: 'El apellido es un campo obligatorio'
                },
                stringLength :{
                	message: 'El apellido es de 3 a 100 caracteres',
                	min : 3,
                	max : 100
                }
            }
        },
        "fechaNacimiento": {
    		selector : '#id_reg_fecha_nacimiento',
            validators: {
            	notEmpty: {
                    message: 'La fecha de Nacimiento es un campo obligatorio'
                },
                remote :{
                	delay   : 1000,
                	url     : 'buscaEmpleadoMayorEdad',
                	message : 'El empleado debe ser mayor de edad'
                }
            }
        },
        "pais.idPais": {
    		selector : '#id_reg_pais',
            validators: {
            	notEmpty: {
                    message: 'El país un campo obligatorio'
                },
            }
        },
    	
    }   
});
</script>

</html>