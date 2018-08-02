//
//  Services.m
//  TecnoLevel
//
//  Created by Gerardo Zamudio on 02/01/18.
//  Copyright © 2018 Edison Effect. All rights reserved.
//

#import "Services.h"
#import "Reachability.h"

@implementation Services

                                                            #pragma mark -
                                                            #pragma mark ***** Funciones *****


/**
 Prepara para enviar un web services al servidor.
 */
- (void) sendHTTPWebServices
{
    if ([self thereInternetConnection])
    {
        //                                                      //Bandera que se activa por que se esta enviando un servicio.
        _boolSendService = YES;

        [self configurationSession];
    }
    else
    {
        _boolSendService = NO;
        [[self delegate]error:NSLocalizedString(@"There is no Internet conection", nil) service:_typeServices code:0];
    }
}

/**
 Configura la sesión dependiendo del encabezado que se
    requiera.
 */
- (void)configurationSession
{
    //                                                      //Configuración.
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    switch (_typeHeaders)
    {
        case ZDHeaderJson:
            sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
            break;
        case ZDHeaderJsonBasicAuth:
        {
            sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json", @"Authorization": [self defineCredentialsAuthorization]};
        }
            break;
        default:
            sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
            break;
    }

    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [self configurationRequest:session];
}

/**
 Configura la solicitud y la envia.

 @param session Session.
 */
- (void)configurationRequest:(NSURLSession *)session;
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    request.HTTPMethod = _strHTTPMethod;
    request.HTTPBody = _dataHTTPBody;

    NSError *error = nil;
    if (!error)
    {
        NSURLSessionDataTask *sesionDataTask = [session dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
//            NSLog(@"data: %@", data); NSLog(@"response: %@", response); NSLog(@"error: %@", error);
            if (!error)
            {
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                {
                    //                                      //Background Thread
                    dispatch_async(dispatch_get_main_queue(), ^(void)
                    {
                    //                                  //Run UI Updates
                        [self answerApi:data];
                    });
                });
            }
            else
            {
                self->_boolSendService = NO;
                [[self delegate]error:error.description service:self->_typeServices code:0];
            }
        }];
        // 5
        [sesionDataTask resume];
    }
}

/**
 Rellena el cuerpo del mensaje con los parametros establecidos
 por el servicio y agrega el proyecto.

 @param dictionaryParams Parametros del servicio.
 @return JSON listo.
 */
- (NSData*) getJSONDataBodyService:(NSDictionary *)dictionaryParams
{
    if (dictionaryParams != nil)
    {
        NSDictionary *dictionaryBody = [NSDictionary dictionaryWithObjectsAndKeys:
                                        //                  //Identificador del proyecto en este caso es el 2 (Agua).
                                        PROJECT_ID, @"idProject",
                                        //                  //Saber que viene de la aplicación.
                                        REQUESTED_FROM, @"requestedFrom",
                                        //                  //Parametros con que se le agregan de cada servicio.
                                        dictionaryParams, @"params",
                                        nil];

        NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:dictionaryBody options:NSJSONWritingPrettyPrinted  error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];

        NSLog(@"jsonString:\n%@", jsonString);

        return dataJSON;
    }
    else
    {
        return nil;
    }
}

/**
 Configura la autorización basica para poder tener acceso
 a los servicios.

 @return String con Autorización.
 */
- (NSString *)defineCredentialsAuthorization
{
    //                                                      //Concatena el us
    NSString *strAuthString = [NSString stringWithFormat:@"%@:%@",_username, _password];
    NSLog(@"strAuthString: %@", strAuthString);
    NSData *dataAuth = [strAuthString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strAuthValue = [NSString stringWithFormat:@"Basic %@", [dataAuth base64EncodedStringWithOptions:0]];

    return strAuthValue;
}


                                                            #pragma mark -
                                                            #pragma mark ***** Metodos *****

- (BOOL)thereInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];

    if (
        internetStatus != NotReachable
        )
        return TRUE;
    else
        return FALSE;
}

- (void) sendPOSTWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams
{
     [self sendWebServiceHTTPMethodTypeTo:@"POST" typeServices:service nameService:strNameService params:dictionaryParams];
}

- (void) sendPUTWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams
{
    [self sendWebServiceHTTPMethodTypeTo:@"PUT" typeServices:service nameService:strNameService params:dictionaryParams];
}

- (void) sendGETWebServiceTo:(int)service nameService:(NSString *)strNameService
{
    [self sendWebServiceHTTPMethodTypeTo:@"GET" typeServices:service nameService:strNameService params:nil];
}

- (void) sendDELETEWebServiceTo:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams
{
    [self sendWebServiceHTTPMethodTypeTo:@"DELETE" typeServices:service nameService:strNameService params:dictionaryParams];
}

- (void)sendWebServiceHTTPMethodTypeTo:(NSString *)strMethodType typeServices:(int)service nameService:(NSString *)strNameService params:(NSDictionary *)dictionaryParams
{
    //                                                      //Se concatena la pagina donde se envia el servicio y con el
    //                                                      //      nombre del servicio para formar la URL completa.
    NSString *strURL = [NSString stringWithFormat:@"%@%@", SERVER_IP, strNameService];
    NSLog(@"strURL: %@", strURL);
    _url = [NSURL URLWithString:strURL];
    _strHTTPMethod = strMethodType;
    _typeServices = service;
    _dataHTTPBody = [self getJSONDataBodyService:dictionaryParams];

    [self sendHTTPWebServices];
}

- (void)sendTestWebServices
{
    _url = [NSURL URLWithString:@"https://www.cuantumlabs.com/IoTTest/Temperature/getAllTemperatureSensor.php"];
    _strHTTPMethod = @"POST";
    _typeServices = ZDServiceCreateUser;
    _typeHeaders = ZDHeaderDefault;

    NSString *token = @"$2y$10$urbfo/U8phYCelIoZTya5eOxM9SUUmlDCgJLjTEa5E8gRsDkpJigS";
    int addressID = 122;
    NSString *strData = [NSString stringWithFormat:@"userToken=%@&addressID=%d", token, addressID];

    _dataHTTPBody = [strData dataUsingEncoding:NSUTF8StringEncoding];

    [self sendHTTPWebServices];

//    [self sendHTTPGet];
}

- (void)getAddressGeocodeMaps:(NSString *)strLatLng
{
    _url = [NSURL URLWithString: [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@&key=%@", strLatLng, API_KEY_GOOGLE]];
    _strHTTPMethod = @"GET";
    _typeServices = ZDServiceGetAddresGoogleMaps;
    _typeHeaders = ZDHeaderDefault;
    _dataHTTPBody = nil;

    [self sendHTTPWebServices];
}

                                                            #pragma mark -
                                                            #pragma mark ***** Delegados *****

/**
 Obtiene la respuesta del servicio y la decifra.

 @param answer Data Server
 */
- (void) answerApi:(NSData *)answer
{
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSData* kivaData = answer;

        //3
        NSDictionary* json = nil;
        if (kivaData) {
            json = [NSJSONSerialization
                    JSONObjectWithData:kivaData
                    options:kNilOptions
                    error:nil];
        }
        //4
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            //5
            [self updateUIWithDictionary: json];
        });

    });
}

/**
 Parser JSON para mandar el servicio.

 @param json JSON
 */
-(void)updateUIWithDictionary:(NSDictionary*)json
{
    //                                                      //Limpia la bandera de que llego el servicio.
    _boolSendService = NO;

    @try
    {
        NSLog(@"Services: %d Json:\n%@", _typeServices, json);

        NSInteger intCode = [json[@"code"] integerValue];

        if (_typeServices == ZDServiceGetAddresGoogleMaps)
        {
            NSString *strStatus = json[@"status"];
            //                                                  //Si la consulta dio resultados
            if ([strStatus isEqualToString:@"OK"])
            {
                [[self delegate]parserData:json service:_typeServices];
            }
            else
            {
                [[self delegate]error:NSLocalizedString(@"Valid location", nil) service:_typeServices code:intCode];
            }
        }
        else
        {
            switch (intCode)
            {
                    //                                              //Todo salio bien.
                case STATUS_OK:
                {
                    NSDictionary *dictionaryMessage = json[@"message"];
                    [[self delegate] parserData:dictionaryMessage service:_typeServices];
                }
                    break;
                default:
                {
                    //                                              //Obtiene el mensaje del servidor.
                    NSString *strMessage = json[@"message"];
                    //                                              //Manda el mensaje a la clase.
                    [[self delegate]error:strMessage service:_typeServices code:intCode];
                }
                    break;
            }
        }
    }
    @catch (NSException *exception)
    {
        NSString *mensaje = [NSString stringWithFormat:NSLocalizedString(@"Unable to parse", nil), exception];
        [[self delegate]error:mensaje service:_typeServices code:0];
    }
}

@end
