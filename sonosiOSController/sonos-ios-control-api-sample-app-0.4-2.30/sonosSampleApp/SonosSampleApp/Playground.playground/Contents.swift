//: Playground - noun: a place where people can play

import UIKit
import ControlApi

let json = "{\"id\":{\"serviceId\":\"1\",\"accountId\":\"3\",\"objectId\":\"2\"},\"artist\":{\"id\":{\"serviceId\":\"1\",\"accountId\":\"3\",\"objectId\":\"2\"},\"name\":\"Pink Floyd\"},\"name\":\"Dark side of the moon\"}"

let album = Album()

let serializer = JsonSerializer()

try? serializer.fromJson(json, object: album)
album.name
album.id
album.id?.serviceId
album.id?.objectId
album.artist?.name
album.artist?.id?.accountId

let serviceJson = "{\"id\":\"id\",\"imageUrl\":\"http:\\/\\/localhost:8080\\/media\\/100\",\"name\":\"Brick in the wall\"}"

let service = Service()
try? serializer.fromJson(serviceJson, object: service)
service.imageUrl
service.id
service.name

let statusJson = "[{\"namespace\":\"playbackMetadata:1\",\"householdId\":\"Sonos_KaQ4s5HVFcARnvFtrSbO4d5Eo7\",\"groupId\":\"RINCON_B8E937B65CB001400:12\",\"type\":\"metadataStatus\"},{\"currentItem\":{\"track\":{\"type\":\"track\",\"name\":\"Ice Ice Baby\",\"id\":{\"serviceId\":\"12\",\"objectId\":\"spotify:track:3XVozq1aeqsJwpXrEZrDJ9\",\"accountId\":\"sn_4\"},\"artist\":{\"name\":\"Vanilla Ice\"},\"album\":{\"name\":\"Vanilla Ice Is Back! - Hip Hop Classics\"},\"imageUrl\":\"http:\\/\\/192.168.1.101:1400\\/getaa?s=1&u=x-sonos-spotify\",\"durationMillis\":254000}},\"nextItem\":{\"track\":{\"type\":\"track\",\"name\":\"Ice Ice Baby\",\"id\":{\"serviceId\":\"12\",\"objectId\":\"spotify:track:3XVozq1aeqsJwpXrEZrDJ9\",\"accountId\":\"sn_4\"},\"artist\":{\"name\":\"Vanilla Ice\"},\"album\":{\"name\":\"Vanilla Ice Is Back! - Hip Hop Classics\"},\"imageUrl\":\"http:\\/\\/192.168.1.101:1400\\/getaa?s=1&u=x-sonos-spotify\",\"durationMillis\":254000}}}]"

let metadataStatus = try! serializer.fromJson(statusJson)

metadataStatus?.body

if let body = metadataStatus!.body as? PlaybackMetadata.MetadataStatus.MetadataStatusBody {
    if let track = body.currentItem?.track as? Track {
        track.name
        track.artist?.name
        track.album?.name
        track.imageUrl
    }

    body.currentItem?.track
    body.nextItem?.track?.trackType
}

let groupVolume = GroupVolume.GroupVolume(groupId: "RINCON_B8E937B65CB001400:12", householdId: "Sonos_KaQ4s5HVFcARnvFtrSbO4d5Eo7", sessionId: nil, cmdId: nil)
let body = GroupVolume.GroupVolume.GroupVolumeBody(volume: 10, muted: false, fixed: false)

groupVolume.body = body

let groupVolumeJson = try! serializer.toJson(groupVolume)
NSLog(groupVolumeJson)
