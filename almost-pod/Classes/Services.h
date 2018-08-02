//
//  Services.h
//  TecnoLevel
//
//  Created by Gerardo Zamudio on 02/01/18.
//  Copyright © 2018 Edison Effect. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AcknowledgmentCodes.h"

@protocol ServicesDelegate
@optional
@required

/**
 Respuesta del servicio cuando todo salio bien.

 @param dictionaryData Informacion que se obtiene del servicio.
 @param typeService Identificador del servicio al cual se llamo.
 */
- (void)parserData:(NSDictionary *)dictionaryData service:(int)typeService;

/**
 Respuesta cuando fue un error del servicio.

 @param strError Mensaje del error en string del servicio.
 @param typeService Identificador del servicio al cual se llamo.
 */
- (void)error:(NSString *)strError service:(int)typeService code:(NSInteger)intCode;

@end

@interface Services : NSObject


typedef enum
{
    ZDServiceDefault = 0,
    //                                                      //1.Crear un usuario
    ZDServiceCreateUser,
    //                                                      //2.Iniciar sesión.
    ZDServiceLoginUser,
    //                                                      //3.Cerrar sesión.
    ZDServiceLogoutUser,
    //                                                      //4.Obtiene la versión de datos.
    ZDServiceGetDataVersion,
    //                                                      //5.Obtiene toda la información del usuario.
    ZDServiceGetAccountInfo,
    //                                                      //6.Direcciondes del google maps
    ZDServiceGetAddresGoogleMaps,
    //                                                      //7.Agregar tanque.
    ZDServiceAddTank,
    //                                                      //8.Actualiza la calibración.
    ZDServiceUpdateCalibrate,
    //                                                      //9.Inserta los niveles del tanque.
    ZDServiceSetTankLevels,
    //                                                      //10.Actualiza la información del tanque.
    ZDServicesUpdateInfoTank,
    //                                                      //11.Elimina el tanque.
    ZDServicesDeleteTank,
    //                                                      //12.Cambia el password.
    ZDServiceChangePassword,
    //                                                      //13.Actualiza la información del usuario.
    ZDServiceUpdateInfoUser,
    //                                                      //14.Recuperar la contraseña.
    ZDServicePasswordForgot
}
TypeServices;

/**
 Para asignar que tipo de servicio fue el que se envio.
 */
@property(nonatomic, assign)TypeServices typeServices;

typedef enum
{
    //                                                      //Header con parametros por default.
    ZDHeaderDefault = 0,
    //                                                      //Header con JSON
    ZDHeaderJson,
    //                                                      //Header con Json y autorización.
    ZDHeaderJsonBasicAuth
}
TypeHeaders;

/**
 Se le asigan que tipo de encabezados tendra el web service
 para configurarlo.
 */
@property(nonatomic, assign)TypeHeaders typeHeaders;

/**
 Delegado para acceder a las funciones de los servicios.
 */
@property(nonatomic, assign)id<ServicesDelegate>delegate;

/**
 Coneccion al Servidor.
 */
@property(retain, nonatomic)NSURLConnection *connection;
@property(retain, nonatomic)NSMutableData *receivedData;

/**
 URL a la cual se va a manadar el servicio.
 */
@property(retain, nonatomic)NSURL *url;

/**
 Tipo de metodo HTTP que se usara (POST, PUT, GET)
 */
@property(retain, nonatomic)NSString *strHTTPMethod;

/**
 Informacion que se envia en el cuerpo del servicio.
 */
@property(retain, nonatomic)NSData *dataHTTPBody;


                                                            #pragma mark -
                                                            #pragma mark ***** Variables *****

/**
 Nombre de usuario en dado caso que el servicio
 requiera autenticacion.
 */
@property(nonatomic, strong)NSString *username;

/**
 Contraseñaen dado caso que el servicio requiera autenticacion.
 */
@property(nonatomic, strong)NSString *password;

/**
 Se activa cuando se envia información al servidor.
 Se libera cuando llegaron los datos.
 */
@property(nonatomic) BOOL boolSendService;

                                                            #pragma mark -
                                                            #pragma mark ***** Metodos *****

/**
 Saber si hay una conexion activa a internet

 @return FALSE si no la hay.
 */
- (BOOL)thereInternetConnection;

/**
 Envia un metodo POST al servidor

 @param service De que servicio viene.
 @param strNameService Nombre del servicio en le servidor.
 @param dictionaryParams Parametros a mandar.
 */
- (void) sendPOSTWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams;

/**
 Envia un metodo PUT al servidor

 @param service De que servicio viene.
 @param strNameService Nombre del servicio en le servidor.
 @param dictionaryParams Parametros a mandar
 */
- (void) sendPUTWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams;

/**
 Envia un metodo GET al servidor.

 @param service De que servicio viene.
 @param strNameService Nombre del servicio en le servidor.
 */
- (void) sendGETWebServiceTo:(int)service nameService:(NSString *)strNameService;

/**
 Envia un metodo DELETE al servidor.

 @param service DE que servicio viene.
 @param strNameService Nombre del servicio.
 @param dictionaryParams Parametros a mandar
 */
- (void) sendDELETEWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams;

/**
 Manda un servicio de prueba pero se tiene que llenar todos
 los datos.
 */
- (void)sendTestWebServices;

/**
 Manda el servicio a Google Maps para obtener la dirección
 del usuario.

 @param strLatLng Latitud y Longitud.
 */
- (void)getAddressGeocodeMaps:(NSString *)strLatLng;

@end
