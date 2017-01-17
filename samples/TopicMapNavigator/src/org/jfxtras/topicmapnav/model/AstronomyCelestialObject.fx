package org.jfxtras.topicmapnav.model;

/**
 * TODO: Currently not being used
 */
public class AstronomyCelestialObject {
  public var astronomyOrbitalRelationshipOrbitedBy:AstronomyOrbitalRelationshipOrbitedBy[];
  public var commonTopicImage: ArtistImage[] ;
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
  };
  public var id: String;
}





