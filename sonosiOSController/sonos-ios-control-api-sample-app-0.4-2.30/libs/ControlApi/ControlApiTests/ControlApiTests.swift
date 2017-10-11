//
// The MIT License (MIT)
//
// Copyright (c) 2016 Sonos, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import XCTest
@testable import ControlApi

class ControlApiTests: XCTestCase {
    fileprivate let serializer: JsonSerializer = JsonSerializer()
    lazy var uid: UniversalMusicObjectId = {
        return UniversalMusicObjectId(serviceId: self.SERVICE_ID, objectId: self.OBJECT_ID, accountId: self.ACCOUNT_ID)
    }()
    lazy var album: Album = {
        return Album(name: self.ALBUM_NAME, artist: self.artist, id: self.uid)
        }()
    lazy var artist: Artist = {
        return Artist(name: self.ARTIST_NAME, id: self.uid)
    }()
    lazy var service: Service = {
        return Service(name: self.TRACK_NAME, id: self.SERVICE_ID, imageUrl: self.IMAGE_URL)
    }()
    lazy var show: Show = {
        return Show(id: self.uid, name: self.TRACK_NAME, host: self.artist, imageUrl: self.IMAGE_URL)
    }()
    lazy var track: Track = {
        return Track(type: self.TRACK_TYPE, name: self.TRACK_NAME, mediaUrl: self.IMAGE_URL,
            imageUrl: self.IMAGE_URL, contentType: self.CONTENT_TYPE, album: self.album,
            artist: self.artist, id: self.uid, durationMillis: self.DURATION_MILLIS,
            trackNumber: self.TRACK_NUMBER)
    }()

    let IMAGE_URL = "http://localhost:8080/media/100"
    let ESCAPED_IMAGE_URL = "http:\\/\\/localhost:8080\\/media\\/100"
    let CONTENT_TYPE = "application/json"
    let TRACK_NAME = "Brick in the wall"
    let ESCAPED_CONTENT_TYPE = "application\\/json"
    let ALBUM_NAME = "Dark side of the moon"
    let ARTIST_NAME = "Pink Floyd"
    let TRACK_NUMBER = 314159
    let DURATION_MILLIS = 360

    let SERVICE_ID = "1"
    let OBJECT_ID = "2"
    let ACCOUNT_ID = "3"
    let TRACK_TYPE = "track"

    let POSITION_MILLIS = 1000
    let ITEM_ID = "1"

    let GROUP_ID = "1234"
    let SESSION_ID = "abcd"
    let HOUSEHOLD_ID = "5678"
    let CMD_ID = "defg"

    let PLAYBACK_NAMESPACE = "playback"
    let PLAYBACK_METADATA_NAMESPACE = "playbackMetadata"
    let PLAYBACK_SESSION_NAMESPACE = "playbackSession"
    let GLOBAL_NAMESPACE = "global"
    let GROUP_VOLUME_NAMESPACE = "groupVolume"

    override func setUp() {
        super.setUp()
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTrackEmpty() {
        checkMessage(Track(), expectedJson: "{}", emptyObject: Track())
    }

    func testTrackMembersNonEmpty() {
        checkMessage(track, expectedJson: "{\"name\":\"" + TRACK_NAME + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\"," +
            "\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"contentType\":\"" + ESCAPED_CONTENT_TYPE +
            "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" +
            ",\"trackNumber\":" + "\(TRACK_NUMBER)" + ",\"type\":\"track\"}", emptyObject: Track())
    }

    func testAlbumEmpty() {
        checkMessage(Album(), expectedJson: "{}", emptyObject: Album())
    }

    func testAlbumMembersNonEmpty() {
        checkMessage(album, expectedJson: "{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"}", emptyObject: Album())
    }

    func testArtistEmpty() {
        checkMessage(Artist(), expectedJson: "{}", emptyObject: Artist())
    }

    func testArtistMembersNonEmpty() {
        checkMessage(artist, expectedJson: "{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"}", emptyObject: Artist())
    }

    func testMusicObjectIdEmpty() {
        let id = UniversalMusicObjectId()
        checkMessage(id, expectedJson: "{\"serviceId\":null,\"accountId\":null,\"objectId\":null}",
            emptyObject: UniversalMusicObjectId())
    }

    func testMusicObjectIdMembersNonEmpty() {
        checkMessage(uid, expectedJson: "{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"}", emptyObject: UniversalMusicObjectId())
    }

    func testAudioBookEmpty() {
        checkMessage(AudioBook(), expectedJson: "{\"type\":\"audiobook\"}", emptyObject: AudioBook())
    }

    func testAudioBookMembersNonEmpty() {
        let audioBook = AudioBook(id: uid, name: TRACK_NAME, imageUrl: IMAGE_URL,
            chapterNumber: 12, author: artist, narrator: artist, book: Book())

        checkMessage(audioBook, expectedJson: "{\"author\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + TRACK_NAME +
            "\",\"book\":{},\"type\":\"audiobook\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"imageUrl\":\"" + ESCAPED_IMAGE_URL +
            "\",\"narrator\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"chapterNumber\":12}",
            emptyObject: AudioBook())
    }

    func testBookEmpty() {
        checkMessage(Book(), expectedJson: "{}", emptyObject: Book())
    }

    func testBookMembersNonEmpty() {
        let book = Book(id: uid, name: TRACK_NAME, author: artist,
            imageUrl: IMAGE_URL)

        checkMessage(book, expectedJson: "{\"author\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"imageUrl\":\"" +
            ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + TRACK_NAME + "\"}", emptyObject: Book())
    }

    func testServiceEmpty() {
        checkMessage(Service(), expectedJson: "{}", emptyObject: Service())
    }

    func testServiceMembersNonEmpty() {
        checkMessage(service, expectedJson: "{\"id\":\"" + SERVICE_ID + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL +
            "\",\"name\":\"" + TRACK_NAME + "\"}", emptyObject: Service())
    }

    func testContainerEmpty() {
        checkMessage(Container(), expectedJson: "{}", emptyObject: Container())
    }

    func testContainerMembersNonEmpty() {
        let container = Container(name: TRACK_NAME, type: "type", id: uid,
            service: service, imageUrl: IMAGE_URL)

        checkMessage(container, expectedJson: "{\"name\":\"" + TRACK_NAME + "\",\"service\":{\"id\":\"" + SERVICE_ID +
            "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"name\":\"" + TRACK_NAME + "\"},\"id\":{\"serviceId\":\"" +
            SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"imageUrl\":\"" +
            ESCAPED_IMAGE_URL + "\",\"type\":\"type\"}", emptyObject: Container())
    }

    func testItemEmpty() {
        checkMessage(Item(), expectedJson: "{}", emptyObject: Item())
    }

    func testItemMembersNonEmpty() {
        let item = Item(id: SERVICE_ID, track: Track(type: "track", name: TRACK_NAME, mediaUrl: IMAGE_URL,
            imageUrl: IMAGE_URL, contentType: CONTENT_TYPE, album: album,
            artist: artist, id: uid, durationMillis: DURATION_MILLIS,
            trackNumber: TRACK_NUMBER))

        checkMessage(item, expectedJson: "{\"id\":\"" + SERVICE_ID + "\",\"track\":{\"name\":\"" + TRACK_NAME +
            "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"contentType\":\"" +
            ESCAPED_CONTENT_TYPE + "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" +
            ",\"trackNumber\":" + "\(TRACK_NUMBER)" + ",\"type\":\"track\"}}", emptyObject: Item())
    }

    func testPodcastEmpty() {
        checkMessage(Podcast(), expectedJson: "{}", emptyObject: Podcast())
    }

    func testPodcastMembersNonEmpty() {
        let podcast = Podcast(id: uid, name: TRACK_NAME, imageUrl: IMAGE_URL,
            artist: artist, show: show)

        checkMessage(podcast, expectedJson: "{\"type\":\"podcast\",\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID +
            "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME +
            "\"},\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"show\":{\"imageUrl\":\"" + ESCAPED_IMAGE_URL +
            "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID +
            "\"},\"host\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + TRACK_NAME + "\"},\"name\":\"" + TRACK_NAME +
            "\"}", emptyObject: Podcast())
    }

    func testShowEmpty() {
        checkMessage(Show(), expectedJson: "{}", emptyObject: Show())
    }

    func testShowMembersNonEmpty() {
        checkMessage(show, expectedJson: "{\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" +
            SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID +
            "\"},\"host\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + TRACK_NAME + "\"}",
            emptyObject: Show())
    }

    func testGroupCoordinatorChangedEmpty() {
        checkMessage(Global.GroupCoordinatorChanged(), expectedJson: "[{},{}]", emptyObject: Global.GroupCoordinatorChanged())
    }

    func testGroupCoordinatorChangedMembersNonEmpty() {
        let command = Global.GroupCoordinatorChanged(householdId: HOUSEHOLD_ID, cmdId: CMD_ID, success: nil, response: nil)

        command.body = Global.GroupCoordinatorChanged.GroupCoordinatorChangedBody(groupId: GROUP_ID,
            groupStatus: "GROUP_STATUS_MOVED", groupName: "GroupName", websocketUrl: "ws://localhost:8080", playerId: "abcdef")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GLOBAL_NAMESPACE + "\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"5678\",\"type\":\"groupCoordinatorChanged\"},{\"groupName\":\"GroupName\",\"groupId\":\"" + GROUP_ID +
            "\",\"groupStatus\":\"GROUP_STATUS_MOVED\",\"websocketUrl\":\"ws:\\/\\/localhost:8080\",\"playerId\":\"abcdef\"}]",emptyObject: Global.GroupCoordinatorChanged())
    }

    func testNamespaceMetadataEmpty() {
        checkMessage(NamespaceMetadata(), expectedJson: "{}", emptyObject: NamespaceMetadata())
    }

    func testNamespaceMetadataMembersNonEmpty() {
        let namespaceMetadata = NamespaceMetadata(title: "namespace", version: 2, minVersion: 1)

        checkMessage(namespaceMetadata, expectedJson: "{\"title\":\"namespace\",\"minVersion\":1,\"version\":2}",
            emptyObject: NamespaceMetadata())
    }

    func testGlobalErrorEmpty() {
        checkMessage(GlobalError(), expectedJson: "{}", emptyObject: GlobalError())
    }

    func testGlobalErrorMembersNonEmpty() {
        let globalError = GlobalError(errorCode: "1001", reason: "does not compute")

        checkMessage(globalError, expectedJson: "{\"errorCode\":\"1001\",\"reason\":\"does not compute\"}",
            emptyObject: GlobalError())
    }

    func testQueueItemEmpty() {
        checkMessage(QueueItem(), expectedJson: "{}", emptyObject: QueueItem())
    }

    func testQueueItemMembersNonEmpty() {
        let queueItem = QueueItem(id: "314159", track: track, deleted: false, policies: nil)

        checkMessage(queueItem, expectedJson: "{\"id\":\"314159\"," +
            "\"track\":{\"name\":\"" + TRACK_NAME + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" +
            SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"mediaUrl\":\"" +
            ESCAPED_IMAGE_URL + "\",\"contentType\":\"" + ESCAPED_CONTENT_TYPE + "\",\"album\":{\"id\":{\"serviceId\":\"" +
            SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" +
            ",\"trackNumber\":" + "\(TRACK_NUMBER)" + ",\"type\":\"track\"},\"deleted\":false}", emptyObject: QueueItem())
    }

    func testGroupVolumeSubscribeEmpty() {
        checkMessage(GroupVolume.Subscribe(), expectedJson: "[{},{}]", emptyObject: GroupVolume.Subscribe())
    }

    func testGroupVolumeSubscribeMembersNonEmpty() {
        let command = GroupVolume.Subscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"subscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: GroupVolume.Subscribe())
    }

    func testGroupVolumeUnsubscribeEmpty() {
        checkMessage(GroupVolume.Unsubscribe(), expectedJson: "[{},{}]", emptyObject: GroupVolume.Unsubscribe())
    }

    func testGroupVolumeUnsubscribeMembersNonEmpty() {
        let command = GroupVolume.Unsubscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"unsubscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: GroupVolume.Unsubscribe())
    }

    func testGroupVolumeSetVolumeEmpty() {
        checkMessage(GroupVolume.SetVolume(), expectedJson: "[{},{}]", emptyObject: GroupVolume.SetVolume())
    }

    func testGroupVolumeSetVolumeMembersNonEmpty() {
        let command = GroupVolume.SetVolume(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = GroupVolume.SetVolume.SetVolumeBody(volume: 1)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"setVolume\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"volume\":1}]", emptyObject: GroupVolume.SetVolume())
    }

    func testGroupVolumeSetRelativeVolumeEmpty() {
        checkMessage(GroupVolume.SetRelativeVolume(), expectedJson: "[{},{}]", emptyObject: GroupVolume.SetRelativeVolume())
    }

    func testGroupVolumeSetRelativeVolumeMembersNonEmpty() {
        let command = GroupVolume.SetRelativeVolume(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = GroupVolume.SetRelativeVolume.SetRelativeVolumeBody(volumeDelta: 1)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"setRelativeVolume\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"volumeDelta\":1}]", emptyObject: GroupVolume.SetRelativeVolume())
    }

    func testGroupVolumeSetMuteEmpty() {
        checkMessage(GroupVolume.SetMute(), expectedJson: "[{},{}]", emptyObject: GroupVolume.SetMute())
    }

    func testGroupVolumeSetMuteMembersNonEmpty() {
        let command = GroupVolume.SetMute(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = GroupVolume.SetMute.SetMuteBody(muted: false)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"setMute\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"muted\":false}]", emptyObject: GroupVolume.SetMute())
    }

    func testGroupVolumeGetVolumeEmpty() {
        checkMessage(GroupVolume.GetVolume(), expectedJson: "[{},{}]", emptyObject: GroupVolume.GetVolume())
    }

    func testGroupVolumeGetVolumeMembersNonEmpty() {
        let command = GroupVolume.GetVolume(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"getVolume\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: GroupVolume.SetMute())
    }

    func testGroupVolumeGroupVolumeEmpty() {
        checkMessage(GroupVolume.GroupVolume(), expectedJson: "[{},{}]", emptyObject: GroupVolume.GroupVolume())
    }

    func testGroupVolumeGroupVolumeMembersNonEmpty() {
        let command = GroupVolume.GroupVolume(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID, success: nil,
            response: nil)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"type\":\"" + GROUP_VOLUME_NAMESPACE + "\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{}]", emptyObject: GroupVolume.GroupVolume())
    }

    func testPlaybackSubscribeEmpty() {
        checkMessage(Playback.Subscribe(), expectedJson: "[{},{}]", emptyObject: Playback.Subscribe())
    }

    func testPlaybackSubscribeMembersNonEmpty() {
        let command = Playback.Subscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"subscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.Subscribe())
    }

    func testPlaybackUnsubscribeEmpty() {
        checkMessage(Playback.Unsubscribe(), expectedJson: "[{},{}]", emptyObject: Playback.Unsubscribe())
    }

    func testPlaybackUnsubscribeMembersNonEmpty() {
        let command = Playback.Unsubscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"unsubscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.Unsubscribe())
    }

    func testPlaybackGetPlaybackStatusEmpty() {
        checkMessage(Playback.GetPlaybackStatus(), expectedJson: "[{},{}]", emptyObject: Playback.GetPlaybackStatus())
    }

    func testPlaybackGetPlaybackStatusMembersNonEmpty() {
        let command = Playback.GetPlaybackStatus(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"getPlaybackStatus\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.GetPlaybackStatus())
    }

    func testPlaybackPlayEmpty() {
        checkMessage(Playback.Play(), expectedJson: "[{},{}]", emptyObject: Playback.Play())
    }

    func testPlaybackPlayMembersNonEmpty() {
        let command = Playback.Play(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"play\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.Play())
    }

    func testPlaybackPauseEmpty() {
        checkMessage(Playback.Pause(), expectedJson: "[{},{}]", emptyObject: Playback.Pause())
    }

    func testPlaybackPauseMembersNonEmpty() {
        let command = Playback.Pause(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"pause\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.Play())
    }

    func testPlaybackSetPlayModesEmpty() {
        checkMessage(Playback.SetPlayModes(), expectedJson: "[{},{}]", emptyObject: Playback.SetPlayModes())
    }

    func testPlaybackSetPlayModesMembersNonEmpty() {
        let playModes = PlayMode(repeat_: false, repeatOne: true, shuffle: false, crossfade: true)
        let command = Playback.SetPlayModes(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = Playback.SetPlayModes.SetPlayModesBody(playModes: playModes)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"setPlayModes\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"playModes\":{\"repeat\":false,\"repeatOne\":true,\"shuffle\":false,\"crossfade\":true}}]",
            emptyObject: Playback.SetPlayModes())
    }

    func testPlaybackSkipToNextTrackEmpty() {
        checkMessage(Playback.SkipToNextTrack(), expectedJson: "[{},{}]", emptyObject: Playback.SkipToNextTrack())
    }

    func testPlaybackSkipToNextTrackMembersNonEmpty() {
        let command = Playback.SkipToNextTrack(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"skipToNextTrack\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: Playback.SkipToNextTrack())
    }

    func testPlaybackSkipToPreviousTrackEmpty() {
        checkMessage(Playback.SkipToPreviousTrack(), expectedJson: "[{},{}]", emptyObject: Playback.SkipToPreviousTrack())
    }

    func testPlaybackSkipToPreviousTrackMembersNonEmpty() {
        let command = Playback.SkipToPreviousTrack(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"skipToPreviousTrack\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{}]", emptyObject: Playback.SkipToPreviousTrack())
    }

    func testPlaybackPlaybackStatusEmpty() {
        checkMessage(Playback.PlaybackStatus(), expectedJson: "[{},{}]", emptyObject: Playback.PlaybackStatus())
    }

    func testPlaybackPlaybackStatusMembersNonEmpty() {
        let command = Playback.PlaybackStatus(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID, success: nil,
            response: nil)
        command.body = Playback.PlaybackStatus.PlaybackStatusBody(playbackState: "PLAYBACK_STATE_IDLE", queueVersion: "321",
                                                                  itemId: ITEM_ID, positionMillis: 1234, playModes: nil, availablePlaybackActions: nil)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"type\":\"playbackStatus\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"playbackState\":\"PLAYBACK_STATE_IDLE\",\"positionMillis\":1234,\"queueVersion\":\"321\",\"itemId\":\"" +
            ITEM_ID + "\"}]", emptyObject: Playback.PlaybackStatus())
    }

    func testPlaybackPlaybackErrorEmpty() {
        checkMessage(Playback.PlaybackError(), expectedJson: "[{},{}]", emptyObject: Playback.PlaybackError())
    }

    func testPlaybackPlaybackErrorMembersNonEmpty() {
        let command = Playback.PlaybackError(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID, success: nil,
            response: nil)
        command.body = Playback.PlaybackError.PlaybackErrorBody(errorCode: "1001", reason: "Server error", itemId: ITEM_ID,
                                                                httpStatus: 500, httpHeaders: ["content-type": "application/json"], queueVersion: "asdf")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"type\":\"playbackError\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"reason\":\"Server error\",\"httpStatus\":500,\"httpHeaders\":{\"content-type\":\"" + ESCAPED_CONTENT_TYPE +
            "\"},\"errorCode\":\"1001\",\"itemId\":\"" + ITEM_ID + "\",\"queueVersion\":\"asdf\"}]", emptyObject: Playback.PlaybackError())
    }

    func testPlaybackPlayModeEmpty() {
        checkMessage(PlayMode(), expectedJson: "{}", emptyObject: PlayMode())
    }

    func testPlaybackPlayModeMembersNonEmpty() {
        let playMode = PlayMode(repeat_: false, repeatOne: false, shuffle: true, crossfade: true)

        checkMessage(playMode, expectedJson: "{\"repeat\":false,\"repeatOne\":false,\"shuffle\":true,\"crossfade\":true}",
            emptyObject: PlayMode())
    }

    func testPlaybackMetadataSubscribeEmpty() {
        checkMessage(PlaybackMetadata.Subscribe(), expectedJson: "[{},{}]", emptyObject: PlaybackMetadata.Subscribe())
    }

    func testPlaybackMetaDataSubscribeMembersNonEmpty() {
        let command = PlaybackMetadata.Subscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_METADATA_NAMESPACE + "\",\"groupId\":\"" +
            GROUP_ID + "\",\"command\":\"subscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{}]", emptyObject: PlaybackMetadata.Subscribe())
    }

    func testPlaybackMetadataUnsubscribeEmpty() {
        checkMessage(PlaybackMetadata.Unsubscribe(), expectedJson: "[{},{}]", emptyObject: PlaybackMetadata.Unsubscribe())
    }

    func testPlaybackMetadataUnsubscribeMembersNonEmpty() {
        let command = PlaybackMetadata.Unsubscribe(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_METADATA_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"command\":\"unsubscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID + "\"},{}]",
            emptyObject: PlaybackMetadata.Unsubscribe())
    }

    func testPlaybackMetadataMetadataStatusEmpty() {
        checkMessage(PlaybackMetadata.MetadataStatus(), expectedJson: "[{},{}]", emptyObject: PlaybackMetadata.MetadataStatus())
    }

    func testPlaybackMetadataMetadataStatusMembersNonEmpty() {
        let queueItem = QueueItem(id: "314159", track: track, deleted: false, policies: nil)

        let container = Container(name: TRACK_NAME, type: "type", id: uid,
            service: service, imageUrl: IMAGE_URL)

        let command = PlaybackMetadata.MetadataStatus(groupId: GROUP_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID, success: nil,
            response: nil)
        command.body = PlaybackMetadata.MetadataStatus.MetadataStatusBody(container: container, currentItem: queueItem,
            nextItem: queueItem)

        let empty = PlaybackMetadata.MetadataStatus()
        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_METADATA_NAMESPACE + "\",\"groupId\":\"" + GROUP_ID +
            "\",\"type\":\"metadataStatus\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\"},{\"currentItem\":{\"id\":\"314159\",\"track\":{\"name\":\"" +
            TRACK_NAME + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID +
            "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL +
            "\",\"contentType\":\"" + ESCAPED_CONTENT_TYPE + "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID +
            "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" +
            SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" +
            ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID +
            "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME +
            "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" + ",\"trackNumber\":" + "\(TRACK_NUMBER)" +
            ",\"type\":\"track\"},\"deleted\":false},\"nextItem\":{\"id\":\"314159\"," +
            "\"track\":{\"name\":\"" + TRACK_NAME + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL +
            "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID +
            "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"contentType\":\"" + ESCAPED_CONTENT_TYPE +
            "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID +
            "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME +
            "\"},\"name\":\"" + ALBUM_NAME + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" +
            "\(DURATION_MILLIS)" + ",\"trackNumber\":" + "\(TRACK_NUMBER)" +
            ",\"type\":\"track\"},\"deleted\":false},\"container\":{\"name\":\"" + TRACK_NAME + "\",\"service\":{\"id\":\"" +
            SERVICE_ID + "\",\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"name\":\"" + TRACK_NAME +
            "\"},\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID +
            "\"},\"imageUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"type\":\"type\"}}]", emptyObject: empty )
    }

    func testPlaybackSessionSubscribeEmpty() {
        checkMessage(PlaybackMetadata.Subscribe(), expectedJson: "[{},{}]", emptyObject: PlaybackMetadata.Subscribe())
    }

    func testPlaybackSessionSubscribeMembersNonEmpty() {
        let command = PlaybackSession.Subscribe(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"subscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{}]", emptyObject: PlaybackSession.Subscribe())
    }

    func testPlaybackSessionUnsubscribeEmpty() {
        checkMessage(PlaybackSession.Unsubscribe(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.Unsubscribe())
    }

    func testPlaybackSessionUnsubscribeMembersNonEmpty() {
        let command = PlaybackSession.Unsubscribe(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"unsubscribe\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{}]", emptyObject: PlaybackSession.Unsubscribe())
    }

    func testPlaybackSessionJoinOrCreateSessionEmpty() {
        checkMessage(PlaybackSession.JoinOrCreateSession(), expectedJson: "[{},{}]",
            emptyObject: PlaybackSession.JoinOrCreateSession())
    }

    func testPlaybackSessionJoinOrCreateSessionMembersNonEmpty() {
        let command = PlaybackSession.JoinOrCreateSession(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.JoinOrCreateSession.JoinOrCreateSessionBody(appId: "myApp", appContext: "myContext", accountId: "myAccountId",
            customData: "customData")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"joinOrCreateSession\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"appContext\":\"myContext\",\"accountId\":\"myAccountId\",\"customData\":\"customData\"," +
            "\"appId\":\"myApp\"}]", emptyObject: PlaybackSession.JoinOrCreateSession())
    }

    func testPlaybackSessionJoinSessionEmpty() {
        checkMessage(PlaybackSession.JoinSession(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.JoinSession())
    }

    func testPlaybackSessionJoinSessionMembersNonEmpty() {
        let command = PlaybackSession.JoinSession(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.JoinSession.JoinSessionBody(appId: "myApp", appContext: "myContext")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"joinSession\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"appContext\":\"myContext\",\"appId\":\"myApp\"}]",
            emptyObject: PlaybackSession.JoinSession())
    }

    func testPlaybackSessionCreateSessionEmpty() {
        checkMessage(PlaybackSession.CreateSession(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.CreateSession())
    }

    func testPlaybackSessionCreateSessionMembersNonEmpty() {
        let command = PlaybackSession.CreateSession(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.CreateSession.CreateSessionBody(appId: "myApp", appContext: "myContext",
                                                                       accountId: "myAccountId", customData: "customData")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"createSession\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"appContext\":\"myContext\",\"accountId\":\"myAccountId\",\"customData\":\"customData\"," +
            "\"appId\":\"myApp\"}]", emptyObject: PlaybackSession.CreateSession())
    }

    func testPlaybackSessionLeaveSessionEmpty() {
        checkMessage(PlaybackSession.LeaveSession(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.LeaveSession())
    }

    func testPlaybackSessionLeaveSessionMembersNonEmpty() {
        let command = PlaybackSession.LeaveSession(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"leaveSession\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{}]", emptyObject: PlaybackSession.LeaveSession())
    }

    func testPlaybackSessionLoadCloudQueueEmpty() {
        checkMessage(PlaybackSession.LoadCloudQueue(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.LoadCloudQueue())
    }

    func testPlaybackSessionLoadCloudQueueMembersNonEmpty() {
        let command = PlaybackSession.LoadCloudQueue(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.LoadCloudQueue.LoadCloudQueueBody(queueBaseUrl: "http://localhost:8080/",
                                                                         httpAuthorization: "abcdefgh", itemId: ITEM_ID, queueVersion: "asdf", positionMillis: 1000, playOnCompletion: false, trackMetadata: track)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"loadCloudQueue\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"trackMetadata\":{\"name\":\"" + TRACK_NAME + "\",\"imageUrl\":\"" +
            ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"contentType\":\"" +
            ESCAPED_CONTENT_TYPE + "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" +
            ",\"trackNumber\":" + "\(TRACK_NUMBER)" + ",\"type\":\"track\"},\"queueVersion\":\"asdf\",\"positionMillis\":" + "\(POSITION_MILLIS)" +
            ",\"httpAuthorization\":\"abcdefgh\",\"queueBaseUrl\":\"http:\\/\\/localhost:8080\\/\",\"playOnCompletion\":" +
            "false,\"itemId\":\"" + ITEM_ID + "\"}]", emptyObject: PlaybackSession.LoadCloudQueue())
    }

    func testPlaybackSessionRefreshCloudQueueEmpty() {
        checkMessage(PlaybackSession.RefreshCloudQueue(), expectedJson: "[{},{}]",
            emptyObject: PlaybackSession.RefreshCloudQueue())
    }

    func testPlaybackSessionRefreshCloudQueueMembersNonEmpty() {
        let command = PlaybackSession.RefreshCloudQueue(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"refreshCloudQueue\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{}]", emptyObject: PlaybackSession.RefreshCloudQueue())
    }

    func testPlaybackSessionSkipToItemEmpty() {
        checkMessage(PlaybackSession.SkipToItem(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.SkipToItem())
    }

    func testPlaybackSessionSkipToItemMembersNonEmpty() {
        let command = PlaybackSession.SkipToItem(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.SkipToItem.SkipToItemBody(itemId: ITEM_ID, queueVersion: "1",
            positionMillis: 1000, playOnCompletion: true, trackMetadata: track)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"skipToItem\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"trackMetadata\":{\"name\":\"" + TRACK_NAME + "\",\"imageUrl\":\"" +
            ESCAPED_IMAGE_URL + "\",\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"mediaUrl\":\"" + ESCAPED_IMAGE_URL + "\",\"contentType\":\"" +
            ESCAPED_CONTENT_TYPE + "\",\"album\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID +
            "\",\"objectId\":\"" + OBJECT_ID + "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" +
            ACCOUNT_ID + "\",\"objectId\":\"" + OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"name\":\"" + ALBUM_NAME +
            "\"},\"artist\":{\"id\":{\"serviceId\":\"" + SERVICE_ID + "\",\"accountId\":\"" + ACCOUNT_ID + "\",\"objectId\":\"" +
            OBJECT_ID + "\"},\"name\":\"" + ARTIST_NAME + "\"},\"durationMillis\":" + "\(DURATION_MILLIS)" +
            ",\"trackNumber\":" + "\(TRACK_NUMBER)" + ",\"type\":\"track\"},\"positionMillis\":" + "\(POSITION_MILLIS)" +
            ",\"queueVersion\":\"1\",\"playOnCompletion\":true,\"itemId\":\"" + ITEM_ID + "\"}]",
            emptyObject: PlaybackSession.SkipToItem())
    }

    func testPlaybackSessionSeekEmpty() {
        checkMessage(PlaybackSession.Seek(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.Seek())
    }

    func testPlaybackSessionSeekMembersNonEmpty() {
        let command = PlaybackSession.Seek(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID)
        command.body = PlaybackSession.Seek.SeekBody(itemId: ITEM_ID, positionMillis: 1000)

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"command\":\"seek\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"positionMillis\":" + "\(POSITION_MILLIS)" +
            ",\"itemId\":\"" + ITEM_ID + "\"}]", emptyObject: PlaybackSession.Seek())
    }

    func testPlaybackSessionSessionStatusEmpty() {
        checkMessage(PlaybackSession.SessionStatus(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.SessionStatus())
    }

    func testPlaybackSessionSessionStatusMembersNonEmpty() {
        let command = PlaybackSession.SessionStatus(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID,
            success: nil, response: nil)
        command.body = PlaybackSession.SessionStatus.SessionStatusBody(sessionState: "SESSION_STATE_CONNECTED",
            sessionId: SESSION_ID, sessionCreated: false, customData: "customData")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"type\":\"sessionStatus\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"sessionState\":\"SESSION_STATE_CONNECTED\"," +
            "\"sessionCreated\":false,\"customData\":\"customData\",\"sessionId\":\"" + SESSION_ID + "\"}]",
            emptyObject: PlaybackSession.SessionStatus())
    }

    func testPlaybackSessionSessionErrorEmpty() {
        checkMessage(PlaybackSession.SessionError(), expectedJson: "[{},{}]", emptyObject: PlaybackSession.SessionError())
    }

    func testPlaybackSessionSessionErrorMembersNonEmpty() {
        let command = PlaybackSession.SessionError(sessionId: SESSION_ID, householdId: HOUSEHOLD_ID, cmdId: CMD_ID,
            success: nil, response: nil)
        command.body = PlaybackSession.SessionError.SessionErrorBody(errorCode: "1001", reason: "Some error")

        checkMessage(command, expectedJson: "[{\"namespace\":\"" + PLAYBACK_SESSION_NAMESPACE +
            "\",\"type\":\"sessionError\",\"cmdId\":\"" + CMD_ID + "\",\"householdId\":\"" + HOUSEHOLD_ID +
            "\",\"sessionId\":\"" + SESSION_ID + "\"},{\"errorCode\":\"1001\",\"reason\":\"Some error\"}]",
            emptyObject: PlaybackSession.SessionError())
    }

    func checkMessage<T>(_ message: T, expectedJson: String, emptyObject: T) where T: Serializable {
        var expectedJson = expectedJson
        do {
            let json = try serializer.toJson(message)

            let namespaceRegEx = try NSRegularExpression(pattern: "\"namespace\":\"([^\"]*)\"",
                options: NSRegularExpression.Options.caseInsensitive)

            let matchingOptions = NSRegularExpression.MatchingOptions(rawValue: 0)
            let matchingRange = NSMakeRange(0, expectedJson.lengthOfBytes(using: String.Encoding.ascii))
            let template = "\"namespace\":\"$1:" + "1" + "\""

            expectedJson = namespaceRegEx.stringByReplacingMatches(in: expectedJson, options: matchingOptions,
                range: matchingRange, withTemplate: template)

            do {
                let resultData = json.data(using: String.Encoding.utf8, allowLossyConversion: false)
                let resultObject = try JSONSerialization.jsonObject(with: resultData!,
                    options: JSONSerialization.ReadingOptions(rawValue: 0))

                let expectedData = expectedJson.data(using: String.Encoding.utf8, allowLossyConversion: false)
                let expectedObject = try JSONSerialization.jsonObject(with: expectedData!,
                    options: JSONSerialization.ReadingOptions(rawValue: 0))

                if let resultDictionary = resultObject as? NSDictionary {
                  XCTAssertTrue(resultDictionary == expectedObject as? NSDictionary, json + "\nis not equal to\n" + expectedJson)
                } else if let resultArray = resultObject as? NSArray {
                    XCTAssertTrue(resultArray == expectedObject as? NSArray, json + "\nis not equal to\n" + expectedJson)
                }
            } catch {
                XCTFail("Failed to deserialize message: \(error)")
            }

            try checkDeserialization(json, object: message, deserialized: emptyObject)
        } catch {
            XCTFail()
        }
    }

    func checkDeserialization<T>(_ json: String, object: T, deserialized: T) throws where T: Serializable {
        try serializer.fromJson(json, object: deserialized)
        XCTAssertTrue(object.serialize()!.isEqual(deserialized.serialize()))
    }
}
