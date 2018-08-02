//
//  AcknowledgmentCodes.h
//  TecnoLevel
//
//  Created by Gerardo Zamudio on 09/01/18.
//  Copyright © 2018 Edison Effect. All rights reserved.
//

#ifndef AcknowledgmentCodes_h
#define AcknowledgmentCodes_h
//                                                          //Nombre de la aplicación.
#define APP_NAME                                            @"TecnoLevel"
//                                                          //Nombre de la base de dtaos local almacenada en el iPhone
//#define DATA_BASE_NAME                                      @"WaterDatabase.sqlite"
#define DATA_BASE_NAME                                      @"WaterDB.sqlite"//
//                                                          //URL a la cual se va a consumir el API.
#define SERVER_IP                                           @"https://www.edisoneffect.tech/AWS/"
//                                                          //ApiKey de Google para obtener el mapa y direcciones.
#define API_KEY_GOOGLE                                      @"AIzaSyCY43MkDj_gCxwhRg8RzbeAOrZ-FFV7fOQ"
//                                                          //Identificador del proyecto en este caso es el de Agua que
//                                                          //      se envia en Body en JSON en el web service.
#define PROJECT_ID                                          @"2"
//                                                          //El codigo del idioma en el cual esta el iphone, se usa para
//                                                          //      que el servidor regrese los mensajes traducidos.
#define LENGUAGE                                            NSLocalizedString(@"language", nil)
#define LENGUAGE_EN                                         1
#define LENGUAGE_ES                                         2
//                                                          //Se envia el parametro JSON en el cuerpo del servicio HTTP
//                                                          //      es para saber que viene de la aplicación móvil.
#define REQUESTED_FROM                                      @"app"

//                                                          //LLaves de los UserDefaults para acceder a la memoria.
#define KEY_EMAIL                                           @"email"
#define KEY_ID_CUSTOMER                                     @"idCustomer"
#define KEY_TOKEN_APP                                       @"tokenApp"
#define KEY_ID_AOS                                          @"idAOS"
#define KEY_STATUS_LOG                                      @"statusLog"

//                                                          //Texto de Alertas
#define STR_OK                                              NSLocalizedString(@"OK", nil)
#define STR_CANCEL                                          NSLocalizedString(@"Cancel", nil)
#define STR_ERROR                                           @"Error"
#define STR_MISSING_FIELD                                   NSLocalizedString(@"Information is missing", nil)

#define STATUS_OK                                           200
#define STATUS_UNAUTHORIZED                                 401
#define STATUS_FORBIDDEN                                    403


#endif /* AcknowledgmentCodes_h */
