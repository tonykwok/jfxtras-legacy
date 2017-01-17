package org.jfxtras.topicmapnav.model;

public class TeamTopic {
  public var name: String on replace {
    name = name.replaceAll("&amp;", "&");
  };
  public var id: String;
  public var imageUrl: String;
  public var people:PeopleTopic[];
}





