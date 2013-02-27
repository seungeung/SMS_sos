//
//  DataProvider.m
//  SMS_sos
//
//  Created by GU ZHE on 12-4-12.
//  Copyright (c) 2012年 zhe. All rights reserved.
//

#import "DataProvider.h"
#define POSTURl @"http://192.168.1.27/Service.asmx"
#define HOST @"192.168.1.27"
@implementation DataProvider


+(ASIHTTPRequest *)getASISOAP11Request:(NSString *)WebURL webServiceFile:(NSString *)wsFile xmlNameSpace:(NSString *)xmlNS webServiceName:(NSString *)wsName wsParameters:(NSMutableArray *)wsParas
{
//    soap头
    /*
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
     <soapenv:Header/>
     <soapenv:Body>
     <tem:Import>
     <tem:i>1</tem:i>
     </tem:Import>
     </soapenv:Body>
     </soapenv:Envelope>
     
     
     
     POST http://192.168.1.102/Service.asmx HTTP/1.1
     Accept-Encoding: gzip,deflate
     Content-Type: text/xml;charset=UTF-8
     SOAPAction: "http://tempuri.org/Import"
     User-Agent: Jakarta Commons-HttpClient/3.1
     Host: 192.168.1.102
     Content-Length: 251
     */
//    if ([wsName isEqualToString:@"voice"]) {
        NSString *strVoice = [wsParas objectAtIndex:2];
//    }
//    else
//    {
    NSString *strLoc = [wsParas objectAtIndex:1];
    NSString *strUserID = [wsParas objectAtIndex:0];
//    }
    
    //1、初始化SOAP消息体
    NSString * soapMsgBody = [[NSString alloc] initWithFormat:
//                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                "<soapenv:Header/>"
                                "<soapenv:Body>"
                              "<tem:UserID>"
                              "<!--Optional:-->"
                              "<tem:userId>%@</tem:userId>"
                              "<!--Optional:-->"
                              "<tem:location>%@</tem:location>"
                              "<!--Optional:-->"
                              "<tem:voice>%@</tem:voice>"
                              "</tem:UserID>"
                                "</soapenv:Body>"
                               "</soapenv:Envelope>",strUserID,strLoc,strVoice];
                                


    //请求发送到的路径
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", POSTURl]];
    
    //NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    ASIHTTPRequest * theRequest = [ASIHTTPRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsgBody length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [theRequest addRequestHeader:@"Accept-Encoding" value:@"gzip,deflate"];
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml;charset=UTF-8"];
    [theRequest addRequestHeader:@"SOAPAction" value:@"http://tempuri.org/UserID"];
    
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest addRequestHeader:@"Host" value:HOST];
    [theRequest setRequestMethod:@"POST"];

    [theRequest appendPostData:[soapMsgBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    return theRequest;
}

#pragma mark -
/*
 //Mark: 使用SOAP1.1同步调用WebService请求
 参数 webURL：                远程WebService的地址，不含*.asmx
 参数 webServiceFile：        远程WebService的访问文件名，如service.asmx
 参数 xmlNS：                    远程WebService的命名空间
 参数 webServiceName：        远程WebService的名称
 参数 wsParameters：            调用参数数组，形式为[参数1名称，参数1值，参数2名称，参数2值⋯⋯]，如果没有调用参数，此参数为nil
 */
+ (NSString *)getSOAP11WebServiceResponse:(NSString *) WebURL
                           webServiceFile:(NSString *) wsFile
                             xmlNameSpace:(NSString *) xmlNS
                           webServiceName:(NSString *) wsName
                             wsParameters:(NSMutableArray *) wsParas
{
    //创建请求
    ASIHTTPRequest * theRequest = [self getASISOAP11Request:WebURL
                                             webServiceFile:wsFile
                                               xmlNameSpace:xmlNS
                                             webServiceName:wsName
                                               wsParameters:wsParas];
    
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    //同步调用
    [theRequest startSynchronous];
    NSError *error = [theRequest error];
    if (!error) {
        return [theRequest responseString];
    }
    else {
        //出现调用错误，则使用错误前缀+错误描述
//        return [NSString stringWithFormat:@"%@%@", [Constant sharedConstant].G_WEBSERVICE_ERROR, [error localizedDescription]];
        NSLog(@"error");
        return @"error";
    }
}
#pragma mark -
/*
 //Mark: 使用SOAP1.1同步调用WebService请求，需提供Windows集成验证的用户名、密码和域
 参数 webURL：                远程WebService的地址，不含*.asmx
 参数 webServiceFile：        远程WebService的访问文件名，如service.asmx
 参数 xmlNS：                    远程WebService的命名空间
 参数 webServiceName：        远程WebService的名称
 参数 wsParameters：            调用参数数组，形式为[参数1名称，参数1值，参数2名称，参数2值⋯⋯]，如果没有调用参数，此参数为nil
 参数 userName                用户名--目前来看，不需要输入域信息
 参数 passWord                密码
 */
+ (NSString *)getSOAP11WebServiceResponseWithNTLM:(NSString *) WebURL
                                   webServiceFile:(NSString *) wsFile
                                     xmlNameSpace:(NSString *) xmlNS
                                   webServiceName:(NSString *) wsName
                                     wsParameters:(NSMutableArray *) wsParas
                                         userName:(NSString *) userName
                                         passWord:(NSString *) passWord
{
    //创建请求
    ASIHTTPRequest * theRequest = [self getASISOAP11Request:WebURL
                                             webServiceFile:wsFile
                                               xmlNameSpace:xmlNS
                                             webServiceName:wsName
                                               wsParameters:wsParas];
    
    //集成验证NTLM用户名，密码和域设置
    [theRequest setUsername:userName];
    [theRequest setPassword:passWord];
    //[theRequest setDomain:doMain];
    
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    //同步调用
    [theRequest startSynchronous];
    NSError *error = [theRequest error];
    if (!error) {
        return [theRequest responseString];
    }
    else {
        //出现调用错误，则使用错误前缀+错误描述
//        return [NSString stringWithFormat:@"%@%@", [Constant sharedConstant].G_WEBSERVICE_ERROR, [error localizedDescription]];
        NSLog(@"error");
        return @"error";
    }
}

+ (NSString *)checkResponseError:(NSString *) theResponse
{
    return @"1";
}
@end
