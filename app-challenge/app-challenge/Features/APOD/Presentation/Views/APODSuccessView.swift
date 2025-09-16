import SwiftUI

struct APODSuccessView: View {
    let apod: APODEntity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                APODHeaderView(apod: apod)
                APODImageView(apod: apod)
                APODDescriptionView(apod: apod)
                APODMetadataView(apod: apod)
            }
            .padding()
        }
    }
}

struct APODHeaderView: View {
    let apod: APODEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(apod.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            Text("Date: \(apod.date)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct APODImageView: View {
    let apod: APODEntity
    
    var body: some View {
        AsyncImage(url: URL(string: apod.url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    ProgressView()
                )
        }
        .cornerRadius(12)
    }
}

struct APODDescriptionView: View {
    let apod: APODEntity
    
    var body: some View {
        Text(apod.explanation)
            .font(.body)
            .multilineTextAlignment(.leading)
    }
}

struct APODMetadataView: View {
    let apod: APODEntity
    
    var body: some View {
        HStack {
            Text("Media Type:")
                .fontWeight(.semibold)
            Text(apod.mediaType)
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
}
