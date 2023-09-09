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
            let request = FavoritePost.fetchRequest()
            request.predicate = NSPredicate(format: "id = %d AND userId = %d", item.id, item.userId)
            do {
                let results = try context.fetch(request)
                if let favoriteItem = results.first {
                    context.delete(favoriteItem)
                }
            } catch {
                print("Failed to delete from favorite")
            }
        } else {
            let favoriteItem = FavoritePost(context: context)
            favoriteItem.id = Int32(item.id)
            favoriteItem.userId = Int32(item.userId)
            favoriteItem.title = item.title
            favoriteItem.body = item.body
        }

        saveContext()
    }

    func getAll(userId: Int) -> [PostItem] {
        let context = FavoritePostPersistent.context
        let request: NSFetchRequest<FavoritePost> = FavoritePost.fetchRequest()
        request.predicate = NSPredicate(format: "userId = %d", userId)
        do {
            let results = try context.fetch(request)
            return results.map { PostItem(id: Int($0.id), userId: Int($0.userId), title: $0.title ?? "", body: $0.body ?? "", isFavorite: true) }
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
