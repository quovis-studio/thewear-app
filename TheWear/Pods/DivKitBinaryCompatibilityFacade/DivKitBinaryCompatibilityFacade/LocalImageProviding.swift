import UIKit

internal import DivKit
internal import VGSL

public protocol LocalImageProviding {
  func localImage(for url: URL) -> UIImage?
}

final class LocalImageHolderFactory: DivImageHolderFactory {
  private let localImageProvider: LocalImageProviding
  private let imageHolderFactory: DivImageHolderFactory

  init(
    localImageProvider: LocalImageProviding,
    imageHolderFactory: DivImageHolderFactory
  ) {
    self.localImageProvider = localImageProvider
    self.imageHolderFactory = imageHolderFactory
  }

  func make(_ url: URL?, _ placeholder: ImagePlaceholder?) -> ImageHolder {
    if let url, let localImage = localImageProvider.localImage(for: url) {
      return localImage
    }
    return imageHolderFactory.make(url, placeholder)
  }
}

final class DefaultImageHolderFactory: DivImageHolderFactory {
  private let requester: URLResourceRequesting

  private let imageProcessingQueue = OperationQueue(
    name: "tech.divkit.facade.image-processing",
    qos: .userInitiated
  )

  init(
    requestPerformer: URLRequestPerforming
  ) {
    self.requester = NetworkURLResourceRequester(performer: requestPerformer)
  }

  func make(_ url: URL?, _ placeholder: ImagePlaceholder?) -> ImageHolder {
    guard let url else {
      return placeholder?.toImageHolder() ?? NilImageHolder()
    }
    return RemoteImageHolder(
      url: url,
      placeholder: placeholder,
      requester: requester,
      imageProcessingQueue: imageProcessingQueue
    )
  }
}
