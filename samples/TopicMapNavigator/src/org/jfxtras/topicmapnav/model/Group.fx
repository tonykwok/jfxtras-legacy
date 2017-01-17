package org.jfxtras.topicmapnav.model;

public class Group {
    public var commonTopicImage: ArtistImage[] ;
    public var musicMusicalGroupMember: MusicMusicalGroupMember[];
    public var name: String on replace {
      name = name.replaceAll("&amp;", "&");
    };
    public var id: String;
}
