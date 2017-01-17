/*
 * Tango.fx
 *
 * Created on 30-Oct-2009, 15:53:51
 */

package tango;

import javafx.fxd.FXDNode;
import javafx.scene.image.Image;
import org.jfxtras.util.XMap;

/**
 * @author David
 */

public class Tango 
  {

  }

var cachedImages: XMap = XMap {};

public function getFXDNode(name: String, size: Float) : FXDNode
  {
//  var sr = cachedImages.getValue(name) as SoftReference;
//  var node: FXDNode = sr.get() as FXDNode;
  var node: FXDNode = cachedImages.getValue(name) as FXDNode;

  if (node == null)
    {
    node = FXDNode {
      url: "{__DIR__}scalable/{name}.fxz"
      backgroundLoading: false
      };
    }
//    cachedImages.put(name, new SoftReference(node));
  cachedImages.put(name, node);
  node.scaleX = size / 48.0;
  node.scaleY = size / 48.0;
  return javafx.fxd.Duplicator.duplicate(node) as FXDNode;
  }

var cachedIcons: XMap = XMap {};

public function getIcon(name: String) : Image
  {
//  var sr = cachedImages.getValue(name) as SoftReference;
//  var node: FXDNode = sr.get() as FXDNode;
  var icon: Image = cachedIcons.getValue(name) as Image;

  if (icon == null)
    {
    icon = Image {
      url: "{__DIR__}small/{name}.png"
      backgroundLoading: false
      };
    }
//    cachedImages.put(name, new SoftReference(node));
  cachedIcons.put(name, icon);
  return icon;
  }



public def actions =	[
	"address-book-new",
	"appointment-new",
	"bookmark-new",
	"contact-new",
	"document-new",
	"document-open",
	"document-print",
	"document-print-preview",
	"document-properties",
	"document-save",
	"document-save-as",
	"edit-clear",
	"edit-copy",
	"edit-cut",
	"edit-delete",
	"edit-find",
	"edit-find-replace",
	"edit-paste",
	"edit-redo",
	"edit-select-all",
	"edit-undo",
	"folder-new",
	"format-indent-less",
	"format-indent-more",
	"format-justify-center",
	"format-justify-fill",
	"format-justify-left",
	"format-justify-right",
	"format-text-bold",
	"format-text-italic",
	"format-text-strikethrough",
	"format-text-underline",
	"go-bottom",
	"go-down",
	"go-first",
	"go-home",
	"go-jump",
	"go-last",
	"go-next",
	"go-previous",
	"go-top",
	"go-up",
	"list-add",
	"list-remove",
	"mail-forward",
	"mail-message-new",
	"mail-mark-junk",
	"mail-mark-not-junk",
	"mail-reply-all",
	"mail-reply-sender",
	"mail-send-receive",
	"media-eject",
	"media-playback-pause",
	"media-playback-start",
	"media-playback-stop",
	"media-record",
	"media-seek-backward",
	"media-seek-forward",
	"media-skip-backward",
	"media-skip-forward",
	"process-stop",
	"system-lock-screen",
	"system-log-out",
	"system-search",
	"system-shutdown",
	"tab-new",
	"view-fullscreen",
	"view-refresh",
	"window-new",
  ];

public def apps =	[
	"accessories-calculator",
	"accessories-character-map",
	"accessories-text-editor",
	"help-browser",
	"internet-group-chat",
	"internet-mail",
	"internet-news-reader",
	"internet-web-browser",
	"office-calendar",
	"preferences-desktop-accessibility",
	"preferences-desktop-assistive-technology",
	"preferences-desktop-font",
	"preferences-desktop-keyboard-shortcuts",
	"preferences-desktop-locale",
	"preferences-desktop-multimedia",
	"preferences-desktop-remote-desktop",
	"preferences-desktop-screensaver",
	"preferences-desktop-theme",
	"preferences-desktop-wallpaper",
	"preferences-system-network-proxy",
	"preferences-system-session",
	"preferences-system-windows",
	"system-file-manager",
	"system-installer",
	"system-software-update",
	"system-users",
	"utilities-system-monitor",
	"utilities-terminal",
  ];
public def categories = [
	"applications-accessories",
	"applications-development",
	"applications-games",
	"applications-graphics",
	"applications-internet",
	"applications-multimedia",
	"applications-office",
	"applications-other",
	"applications-system",
	"preferences-desktop",
	"preferences-desktop-peripherals",
	"preferences-system",
  ];
public def devices = [
	"audio-card",
	"audio-input-microphone",
	"battery",
	"camera-photo",
	"camera-video",
	"computer",
	"drive-optical",
	"drive-harddisk",
	"drive-removable-media",
	"input-gaming",
	"input-keyboard",
	"input-mouse",
	"media-optical",
	"media-floppy",
	"media-flash",
	"multimedia-player",
	"network-wired",
	"network-wireless",
	"printer",
	"video-display",
  ];
public def emblems =	[
	"emblem-favorite",
	"emblem-important",
	"emblem-photos",
	"emblem-readonly",
	"emblem-symbolic-link",
	"emblem-system",
	"emblem-unreadable",
  ];
public def emotes = [
	"face-angel",
	"face-crying",
	"face-devilish",
	"face-glasses",
	"face-grin",
	"face-kiss",
	"face-monkey",
	"face-plain",
	"face-sad",
	"face-smile",
	"face-smile-big",
	"face-surprise",
	"face-wink",
  ];
public def mimetypes =	[
	"application-certificate",
	"application-x-executable",
	"audio-x-generic",
	"font-x-generic",
	"image-x-generic",
	"package-x-generic",
	"text-html",
	"text-x-generic",
	"text-x-generic-template",
	"text-x-script",
	"video-x-generic",
	"x-office-address-book",
	"x-office-calendar",
	"x-office-document",
	"x-office-document-template",
	"x-office-drawing",
	"x-office-drawing-template",
	"x-office-presentation",
	"x-office-presentation-template",
	"x-office-spreadsheet",
	"x-office-spreadsheet-template",
  ];
public def places = [
	"folder",
	"folder-remote",
	"folder-saved-search",
	"network-server",
	"network-workgroup",
	"start-here",
	"user-desktop",
	"user-home",
	"user-trash",
  ];
public def status = [
	"audio-volume-high",
	"audio-volume-low",
	"audio-volume-medium",
	"audio-volume-muted",
	"battery-caution",
	"dialog-error",
	"dialog-information",
	"dialog-warning",
	"folder-drag-accept",
	"folder-open",
	"folder-visiting",
	"image-loading",
	"image-missing",
	"mail-attachment",
	"network-error",
	"network-idle",
	"network-offline",
	"network-receive",
	"network-transmit",
	"network-transmit-receive",
	"network-wireless-encrypted",
	"printer-error",
	"software-update-available",
	"software-update-urgent",
	"user-trash-full",
	"weather-clear",
	"weather-clear-night",
	"weather-few-clouds",
	"weather-few-clouds-night",
	"weather-overcast",
	"weather-severe-alert",
	"weather-showers",
	"weather-showers-scattered",
	"weather-snow",
	"weather-storm",
  ];
