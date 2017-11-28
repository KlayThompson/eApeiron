//
//  NetworkAPIManager.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "NetworkAPIManager.h"
#import "HostURL.h"
#import "UserInfoManager.h"

static NetworkAPIManager *shareManager = nil;
@implementation NetworkAPIManager

+ (NetworkAPIManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UserInfoManager *manager = [UserInfoManager shareInstance];
        shareManager = [[NetworkAPIManager alloc] initWithBaseURL:[NSURL URLWithString:manager.serverPathUrl]];
    });
    
    return shareManager;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    self.requestSerializer.timeoutInterval = 15;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"image/png",nil];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    self.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block{
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //检查Token是否过期
    if ([manager checkUserShouldRequestRefresh_token]) {
        
        NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.refresh_token];
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    IMS_client_id,@"client_id",
                                    IMS_client_secret,@"client_secret",
                                    nil];
        //需要更新Token
        [self POST:@"auth/login/refresh" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DLog(@"\n[获取的数据]:\n%@ \n", responseObject);
            [manager encodeLoginAndRefreshTokenData:responseObject];

            //请求数据
            [self requestJsonDataWithEffectiveTokenWithPath:aPath withParams:params withMethodType:NetworkMethod andBlock:block];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"\n[Resp Error]:\n%@", error);
            block(nil, error);
            if ([error.localizedDescription containsString:@"401"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IMSNeedLogin" object:nil];
            }
        }];
    } else {
        //直接请求
        [self requestJsonDataWithEffectiveTokenWithPath:aPath withParams:params withMethodType:NetworkMethod andBlock:block];
    }
    
    
}

- (void)requestJsonDataWithEffectiveTokenWithPath:(NSString *)aPath
                                       withParams:(NSDictionary*)params
                                   withMethodType:(int)NetworkMethod
                                         andBlock:(void (^)(id data, NSError *error))block{

    UserInfoManager *manager = [UserInfoManager shareInstance];

    NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
    [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //过滤 emoji表情
    NSMutableDictionary *parametersWithoutEmoji=[NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString *key in [params allKeys]) {
        if ([params objectForKey:key]&&[[params objectForKey:key] isKindOfClass:[NSString class]]) {
            [parametersWithoutEmoji setObject:[params objectForKey:key] forKey:key];
        }
        else
        {
            [parametersWithoutEmoji setObject:[params objectForKey:key] forKey:key];
        }
    }

    //打印请求内容，使用GET方式打印，便于在浏览器中调试或发给server端同学调试
    NSMutableString *paraStr = [NSMutableString stringWithString:@"&"];
    if([parametersWithoutEmoji isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary*)parametersWithoutEmoji;
        for(NSString *keystr in dict){
            [paraStr appendFormat:@"%@=%@&",keystr,[parametersWithoutEmoji objectForKey:keystr]];
        }
    }
    DLog(@"\n>>>\n%@%@\n",[[NSURL URLWithString:aPath relativeToURL:self.baseURL] absoluteString]  ,paraStr);


    //发起请求
    switch (NetworkMethod) {
        case Get:{

            [self GET:aPath parameters:parametersWithoutEmoji progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DLog(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
                if ([error.localizedDescription containsString:@"401"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMSNeedLogin" object:nil];
                }
            }];

            break;}
        case Post:{

            [self POST:aPath parameters:parametersWithoutEmoji progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DLog(@"\n[获取的数据]:\n%@ \n", responseObject);
                block(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
                if ([error.localizedDescription containsString:@"401"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMSNeedLogin" object:nil];
                }
            }];

            break;}
        case Put:{
            [self PUT:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DLog(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];

            break;}
        case Delete:{
            [self DELETE:aPath parameters:parametersWithoutEmoji success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DLog(@"\n[Resp]:\n%@:\n", responseObject);
                block(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                DLog(@"\n[Resp Error]:\n%@", error);
                block(nil, error);
            }];

            break;}
        default:
            break;
    }
}

- (void)downloadDataWithFullPath:(NSString *)aPath
                        andBlock:(void (^)(id data, NSError *error))block{
    
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    DLog(@"%@",aPath);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue setMaxConcurrentOperationCount:6];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:20];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"application/octet-stream"];
    
    
    
    NSURL *urlString = [NSURL URLWithString:aPath];
    [manager GET:urlString.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"JSON:%@",responseObject);
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"Error:%@",error);
        block(nil, error);
    }];
    
    
    
}
@end
