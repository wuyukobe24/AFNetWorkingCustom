//
//  NetWork.h
//  AFNetWorking封装
//
//  Created by WangXueqi on 2018/5/31.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "InterfaceAddress.h"

typedef void(^CompleteBlock)(BOOL isSuccess, id root, NSError * error);
@interface NetWork : NSObject
@property(nonatomic,copy)CompleteBlock complete;

+ (instancetype) center;

/**
 * get请求
 * @param path              请求接口
 * @param paras             请求参数
 * @param complete          请求完成回调
 */
+ (void)getRequestPath:(NSString *)path
            parameters:(NSDictionary *)paras
              complete:(CompleteBlock)complete;

/**
 * post请求
 * @param path              请求接口
 * @param paras             请求参数
 * @param complete          请求完成回调
 */
+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
               complete:(CompleteBlock)complete;

/**
 * post请求图片上传(默认文件格式类型为@"image/jpeg")
 * @param path              请求接口
 * @param paras             请求参数
 * @param images            图片数组
 * @param name              与服务端约定的参数 (@"upFile")
 * @param complete          请求完成回调
 */
+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
                 images:(NSArray<UIImage *> *)images
                   name:(NSString *)name
               complete:(CompleteBlock)complete;

/**
 * post请求图片上传
 * @param path              请求接口
 * @param paras             请求参数
 * @param images            图片数组
 * @param name              与服务端约定的参数 (@"upFile")
 * @param fileName          图片名称 (@"%@.png",@"%@.jpeg")
 * @param mimeType          文件格式类型 (@"image/jpeg",@"image/png")
 * @param complete          请求完成回调
 */
+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
                 images:(NSArray<UIImage *> *)images
                   name:(NSString *)name
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
               complete:(CompleteBlock)complete;

/**
 * post请求录音上传（默认文件名称为@"xxx.mp3"，格式为mp3）
 * @param path              请求接口
 * @param paras             请求参数
 * @param url               本地文件路径
 * @param name              与服务端约定的参数 (@"upFile")
 * @param complete          请求完成回调
 */
+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
           voiceFileUrl:(NSURL *)url
                   name:(NSString *)name
               complete:(CompleteBlock)complete;

/**
 * post请求录音上传
 * @param path              请求接口
 * @param paras             请求参数
 * @param url               本地文件路径
 * @param name              与服务端约定的参数 (@"upFile")
 * @param fileName          文件名称 (@"xxx.mp3")
 * @param mimeType          文件格式类型 ([mp3 : application/octet-stream] , [mp4 : video/mp4])
 * @param complete          请求完成回调
 */
+ (void)postRequestPath:(NSString *)path
             parameters:(NSDictionary *)paras
           voiceFileUrl:(NSURL *)url
                   name:(NSString *)name
               fileName:(NSString *)fileName
               mimeType:(NSString *)mimeType
               complete:(CompleteBlock)complete;

@end
