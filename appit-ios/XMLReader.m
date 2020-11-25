//
//  XMLReader.m
//
//  Created by Troy on 9/18/10.
//  Copyright 2010 Troy Brant. All rights reserved.
//

#import "XMLReader.h"

#include <libxml/tree.h>
#include "xsltInternals.h"
#include "transform.h"
#include "xsltutils.h"

NSString *const kXMLReaderTextNodeKey = @"text";
NSArray *specialCharacters;

@interface XMLReader (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end


@implementation XMLReader

#pragma mark -
#pragma mark Public methods

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)error
{
    //XMLReader *reader = [[XMLReader alloc] initWithError:error];
    XMLReader *reader = [XMLReader alloc];
    NSDictionary *rootDictionary = [reader objectWithData:data];
    //[reader release];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLReader dictionaryForXMLData:data error:error];
}

+ (void) initSpecialCharactersArray{
    specialCharacters = @[@"!", @"\"", @"#", @"$", @"%", @"&", @"'", @"(", @")", @"*", @"+", @",", @".", @":", @";", @"<", @"=", @">", @"?", @"@", @"[", @"\\", @"]", @"^", @"_", @"`", @"~"];
}

+ (NSString *) replaceSpecialCharacters:(NSString*) string{
    [XMLReader initSpecialCharactersArray];
    for (NSString *character in specialCharacters) {
        if ([character isEqualToString:@","]){
            string = [string stringByReplacingOccurrencesOfString:character withString:@" "];
        }else{
            string = [string stringByReplacingOccurrencesOfString:character withString:@""];
        }
    }
    return string;
}

- (NSString *) transform:(NSString *)xml xsl:(NSString *)xsl{
//    NSString* filePath = [[NSBundle mainBundle] pathForResource: @"Test" ofType: @"xml"];
//    NSData *xmlMem = [[NSData alloc] initWithContentsOfFile:filePath];
//    NSString* styleSheetPath = [[NSBundle mainBundle] pathForResource: @"Test" ofType:@"xslt"];
    NSData *xmlMem = [xml dataUsingEncoding:NSUTF8StringEncoding];
    
    //write xsl to file
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:xsl options:0];
    NSString *fileName =  @"Documents/BarCode.xslt";
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    NSString *fileData = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    [fileData writeToFile:docPath
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:NULL];
    
    xmlDocPtr doc, res;
    xsltStylesheetPtr sty;
    // tells the libxml2 parser to substitute entities as it parses your file
    xmlSubstituteEntitiesDefault(1);
    // This tells libxml to load external entity subsets
    xmlLoadExtDtdDefaultValue = 1;
    // This following line is only really needed if you want to use XSLT params
    const char *params[3] = { [@"param1" cStringUsingEncoding:NSUTF8StringEncoding], [@"\"paramdata\"" cStringUsingEncoding:NSUTF8StringEncoding], NULL };
    sty = xsltParseStylesheetFile((const xmlChar *)[docPath cStringUsingEncoding: NSUTF8StringEncoding]);
    //doc = xmlParseFile([filePath cStringUsingEncoding: NSUTF8StringEncoding]);
    // This example loads the XML file from a memory location as a sample, you can reference file directly with different xmlParse methods
    doc = xmlParseMemory([xmlMem bytes], [xmlMem length]);
    // Pass in NULL instead of params if you don"t need to use them
    res = xsltApplyStylesheet(sty, doc, params);
    xmlChar* xmlResultBuffer = nil;
    int length = 0;
    xsltSaveResultToString(&xmlResultBuffer, &length, res, sty);
    
    NSString* result = [NSString stringWithCString: (char *)xmlResultBuffer encoding: NSUTF8StringEncoding];
    NSLog(@"Result: %@", result);
    
    free(xmlResultBuffer);
    xsltFreeStylesheet(sty);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);
    xsltCleanupGlobals();
    xmlCleanupParser();
    return result;
}

- (NSString *) transform_mrz:(NSString *)xml {
    //    NSString* filePath = [[NSBundle mainBundle] pathForResource: @"Test" ofType: @"xml"];
    //    NSData *xmlMem = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString* styleSheetPath = [[NSBundle mainBundle] pathForResource:@"MRZParser" ofType:@"xsl" inDirectory:@"/templates/xml"];
    NSData *xmlMem = [xml dataUsingEncoding:NSUTF8StringEncoding];
    
    xmlDocPtr doc, res;
    xsltStylesheetPtr sty;
    // tells the libxml2 parser to substitute entities as it parses your file
    xmlSubstituteEntitiesDefault(1);
    // This tells libxml to load external entity subsets
    xmlLoadExtDtdDefaultValue = 1;
    // This following line is only really needed if you want to use XSLT params
    const char *params[3] = { [@"param1" cStringUsingEncoding:NSUTF8StringEncoding], [@"\"paramdata\"" cStringUsingEncoding:NSUTF8StringEncoding], NULL };
    sty = xsltParseStylesheetFile((const xmlChar *)[styleSheetPath cStringUsingEncoding: NSUTF8StringEncoding]);
    //doc = xmlParseFile([filePath cStringUsingEncoding: NSUTF8StringEncoding]);
    // This example loads the XML file from a memory location as a sample, you can reference file directly with different xmlParse methods
    doc = xmlParseMemory([xmlMem bytes], [xmlMem length]);
    // Pass in NULL instead of params if you don"t need to use them
    res = xsltApplyStylesheet(sty, doc, params);
    xmlChar* xmlResultBuffer = nil;
    int length = 0;
    xsltSaveResultToString(&xmlResultBuffer, &length, res, sty);
    
    NSString* result = [NSString stringWithCString: (char *)xmlResultBuffer encoding: NSUTF8StringEncoding];
    NSLog(@"Result: %@", result);
    
    free(xmlResultBuffer);
    xsltFreeStylesheet(sty);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);
    xsltCleanupGlobals();
    xmlCleanupParser();
    return result;
}

#pragma mark -
#pragma mark Parsing

//- (id)initWithError:(NSError *)error
//{
//    if (self = [super init])
//    {
//        errorPointer = error;
//    }
//    return self;
//}

//- (void)dealloc
//{
//    [dictionaryStack release];
//    [textInProgress release];
//    [super dealloc];
//}

- (NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
//    [dictionaryStack release];
//    [textInProgress release];
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    //[parser setDelegate:self];
    BOOL success = [parser parse];
    
    // Return the stack's root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];

    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];

            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];

        // Reset the text
       // [textInProgress release];
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgress appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    //*errorPointer = parseError;
}

@end
