//
//  FavoritePostPersistent.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation
import CoreData

final class FavoritePostPersistent {

    static let shared = FavoritePostPersistent()
    func togglePostItem(item: PostItem) throws {
        let context = FavoritePostPersistent.context
        if item.isFavorite {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePost")
            request.predicate = NSPredicate(format: "id = %d", item.id)
            do {
                let results = try context.fetch(request)
                if let favoriteItem = results.first as? FavoritePost {
                    context.delete(favoriteItem)
                }
            } catch {
                print("Failed to delete from favorite")
            }
        } else {
            let favoriteItem = FavoritePost(context: context)
            favoriteItem.id = Int32(item.id)
            favoriteItem.title = item.title
            favoriteItem.body = item.body
        }

        saveContext()
    }

    func getAll() -> [PostItem] {
        let context = FavoritePostPersistent.context
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { PostItem(id: Int($0.id), title: $0.title ?? "", body: $0.body ?? "", isFavorite: true) }
        } catch {
            print("Could not load data")
            return []
        }
    }

    func cleanup() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "FavoritePost")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let context = FavoritePostPersistent.context
        let batchDelete = try context.execute(deleteRequest)
            as? NSBatchDeleteResult
        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
    }

    static var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "db")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = FavoritePostPersistent.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
