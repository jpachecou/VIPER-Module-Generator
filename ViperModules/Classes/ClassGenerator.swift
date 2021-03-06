//
//  ClassGenerator.swift
//  ViperModules
//
//  Created by Jonathan Pacheco on 29/12/15.
//  Copyright © 2015 Jonathan Pacheco. All rights reserved.
//

import Cocoa

private enum ClassGeneratorKeys: String {
    case ModuleName         = "{{module_name}}"
    case ProjectName        = "{{project_name}}"
    case DeveloperName      = "{{developer_name}}"
    case OrganizationName   = "{{organization_name}}"
    case CurrentDate        = "{{current_date}}"
}

class ClassGenerator {

    class func generateClass(fileUrl: NSURL, templateUrl: NSURL, model: ModuleModel) {
        self.generateFile(templateUrl, urlFile: fileUrl, model: model)
    }
    
    private class func generateFile(templateUrl: NSURL, urlFile: NSURL, model: ModuleModel) {
        self.createFile(urlFile)
        guard let path = urlFile.path else { return }
        guard let templatePath = templateUrl.path else { return }
        if var text = self.readFileTemplate(templatePath) {
            self.replaceModuleNames(&text, model: model)
            self.writeFile(path, text: text)
        }
    }
    
    private class func createFile(url: NSURL) {
        guard let path = url.path else { return }
        
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(path) {
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
    }
    
    private class func replaceModuleNames(inout text: String, model: ModuleModel) {
        text = text.stringByReplacingOccurrencesOfString(ClassGeneratorKeys.ModuleName.rawValue, withString: model.moduleName)
        text = text.stringByReplacingOccurrencesOfString(ClassGeneratorKeys.ProjectName.rawValue, withString: model.projectName)
        text = text.stringByReplacingOccurrencesOfString(ClassGeneratorKeys.DeveloperName.rawValue, withString: model.developerName)
        text = text.stringByReplacingOccurrencesOfString(ClassGeneratorKeys.OrganizationName.rawValue, withString: model.organizationName)
        text = text.stringByReplacingOccurrencesOfString(ClassGeneratorKeys.CurrentDate.rawValue, withString: self.getCurrentDate())
    }
    
    private class func getCurrentDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.stringFromDate(NSDate())
    }
    
    private class func readFileTemplate(path: String) -> String? {
        do {
            return try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding).description
        } catch { return nil }
    }
    
    private class func writeFile(path: String, text: String) {
        do {
            try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {}
    }
}
