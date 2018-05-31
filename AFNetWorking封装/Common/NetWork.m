//
//  NetWork.m
//  AFNetWorking封装
//
//  Created by WangXueqi on 2018/5/31.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "NetWork.h"

@interface NetWork ()
@property (nonatomic,strong)AFHTTPSessionManager * client;
@end

static NetWork * _networkCenter;
@implementation NetWork

- (instancetype)init {
    if (self = [super init]) {
        _client = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:k_server_base]];
        _client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _client.requestSerializer.timeoutInterval = 20;
        _client.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        //serializer.removesKeysWithNullValues = YES;
        _client.responseSerializer = serializer;
        [_client.requestSerializer setValue:@"ios" forHTTPHeaderField:@"request-type"];
        _client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  @"text/json", @"text/javascript",@"text/html", nil];
        _client.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _client.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
        _client.securityPolicy.validatesDomainName = NO;//是否验证域名
    }
    return self;
}

+ (instancetype)center {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkCenter = [[NetWork alloc]init];
    });
    return _networkCenter;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkCenter = [super allocWithZone:zone];
    });
    return _networkCenter;
}

+ (void)getRequestPath:(NSString *)path
            parameters:(NSDictionary *)paras
              complete:(CompleteBlock)complete
{
    AFHTTPSessionManager *client = [NetWork center].client;
    [client GET:path parameters:paras progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self center] successRequestLogDataWithTask:task parameters:paras responseObject:responseObject];
        if (complete) {
            complete(YES,responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self center] failRequestLogDataWithTask:task parameters:paras error:error];
        if (complete) {
            complete(NO,nil,error);
        }
    }];
}

+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
               complete:(CompleteBlock)complete
{
    AFHTTPSessionManager *client = [NetWork center].client;
    [client POST:path parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self center] successRequestLogDataWithTask:task parameters:paras responseObject:responseObject];
        if (complete) {
            complete(YES,responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self center] failRequestLogDataWithTask:task parameters:paras error:error];
        if (complete) {
            complete(NO,nil,error);
        }
    }];
}

+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
                 images:(NSArray<UIImage *> *)images
                   name:(NSString *)name
               complete:(CompleteBlock)complete
{
    [self postRequestPath:path
               parameters:paras
                   images:images
                     name:name
                 fileName:nil
                 mimeType:@"image/jpeg"
                 complete:complete];
}

+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
                 images:(NSArray<UIImage *> *)images
                   name:(NSString *)name
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
               complete:(CompleteBlock)complete
{
    AFHTTPSessionManager * client = [NetWork center].client;
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager manager];//检测网络
    [client POST:path parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            CGFloat scale = manager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi ? .5 : .3;
            NSData * data = UIImageJPEGRepresentation(images[i], scale);
            //防止图片名为空
            NSString * imageFileName = fileName;
            if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
                NSDateFormatter * formatter = [[ NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString * dateString = [ formatter stringFromDate:[NSDate date]];
                imageFileName = [NSString stringWithFormat:@"%@.jpeg",dateString];
            }
            [formData appendPartWithFileData:data name:name fileName:imageFileName mimeType:mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self center] successRequestLogDataWithTask:task parameters:paras responseObject:responseObject];
        if (complete) {
            complete(YES,responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self center] failRequestLogDataWithTask:task parameters:paras error:error];
        if (complete) {
            complete(NO,nil,error);
        }
    }];
}

+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
           voiceFileUrl:(NSURL *)url
                   name:(NSString *)name
               complete:(CompleteBlock)complete
{
    [self postRequestPath:path
               parameters:paras
             voiceFileUrl:url
                     name:name
                 fileName:@"xxx.mp3"
                 mimeType:@"application/octet-stream"
                 complete:complete];
}

+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
           voiceFileUrl:(NSURL *)url
                   name:(NSString *)name
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
               complete:(CompleteBlock)complete
{
    AFHTTPSessionManager * client = [NetWork center].client;
    client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/jpeg", nil];
    [client POST:[NSString stringWithFormat:@"%@%@",k_server_base,path] parameters:paras constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:url name:name fileName:fileName mimeType:mimeType error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        DebugLog(@"上传进度 ----- %f",progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self center] successRequestLogDataWithTask:task parameters:paras responseObject:responseObject];
        if (complete) {
            complete(YES,responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self center] failRequestLogDataWithTask:task parameters:paras error:error];
        if (complete) {
            complete(NO,nil,error);
        }
    }];
}

- (void)successRequestLogDataWithTask:(NSURLSessionDataTask * _Nonnull)task parameters:(NSDictionary *)paras responseObject:(id _Nullable)responseObject {
    DebugLog(@"上传地址:%@ \n 上传参数:%@ \n 接口返回：%@",task.currentRequest.URL.absoluteString,paras,responseObject);
    if (_complete) {
        _complete(YES,responseObject,nil);
    }
}

- (void)failRequestLogDataWithTask:(NSURLSessionDataTask * _Nullable)task parameters:(NSDictionary *)paras error:(NSError * _Nonnull)error {
    DebugLog(@"上传地址:%@ \n 上传参数:%@ \n 错误信息：%@",task.currentRequest.URL.absoluteString,paras,error);
    if (_complete) {
        _complete(NO,nil,error);
    }
}
@end
