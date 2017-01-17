package org.jfxtras.topicmapnav.model;

public class SpaceflightAstronautMissions {
  public var spaceflightSpaceMissionAstronauts:SpaceflightSpaceMissionAstronauts[];
  public var commonTopicImage: ArtistImage[] ;
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
  };
  public var id: String;
}
