package org.jfxtras.topicmapnav.model;

public class AstronomyOrbitalRelationshipOrbitedBy {
  public var astronomyOrbitalRelationshipOrbitedBy: AstronomyOrbitalRelationshipOrbitedBy[];
  //public var astronomyCelestialObject: AstronomyCelestialObject[];
  public var commonTopicImage: ArtistImage[] ;
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
  };
  public var id: String;
}
