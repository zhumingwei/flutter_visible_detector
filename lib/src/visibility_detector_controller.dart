// Copyright 2018 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'dart:ui' show Rect;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'visibility_detector_layer.dart';

/// A [VisibilityDetectorController] is a singleton object that can perform
/// actions and change configuration for all [VisibilityDetector] widgets.
class VisibilityDetectorController with WidgetsBindingObserver {
  static final _instance = VisibilityDetectorController();
  static VisibilityDetectorController get instance => _instance;

  /// The minimum amount of time to wait between firing batches of visibility
  /// callbacks.
  ///
  /// If set to [Duration.zero], callbacks instead will fire at the end of every
  /// frame.  This is useful for automated tests.
  ///
  /// Changing [updateInterval] will not affect any pending callbacks.  Clients
  /// should call [notifyNow] explicitly to flush them if desired.
  Duration updateInterval = Duration.zero;//const Duration(milliseconds: 300);

  /// Forces firing all pending visibility callbacks immediately.
  ///
  /// This might be desirable just prior to tearing down the widget tree (such
  /// as when switching views or when exiting the application).
  void notifyNow() => VisibilityDetectorLayer.notifyNow();

  /// Forgets any pending visibility callbacks for the [VisibilityDetector] with
  /// the given [key].
  ///
  /// If the widget gets attached/detached, the callback will be rescheduled.
  ///
  /// This method can be used to cancel timers after the [VisibilityDetector]
  /// has been detached to avoid pending timers in tests.
  void forget(Key key) => VisibilityDetectorLayer.forget(key);

  /// Returns the last known bounds for the [VisibilityDetector] with the given
  /// [key] in global coordinates.
  ///
  /// Returns null if the specified [VisibilityDetector] is not visible or is
  /// not found.
  Rect widgetBoundsFor(Key key) => VisibilityDetectorLayer.widgetBounds[key];

  ValueNotifier<AppLifecycleState> _stateNotifier = ValueNotifier(AppLifecycleState.resumed);

  ValueNotifier<AppLifecycleState> get stateNotifier => _stateNotifier;

  AppLifecycleState get currentState => _stateNotifier.value;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed || state == AppLifecycleState.paused) {
      _stateNotifier.value = state;
    }
  }

  void dispose(){
    _stateNotifier?.dispose();
  }

  RouteObserver2 routeObserver = RouteObserver2();
}

class RouteObserver2<R extends Route<dynamic>> extends NavigatorObserver {
  final Map<R, Set<RouteAware2>> _listeners = <R, Set<RouteAware2>>{};

  /// Subscribe [routeAware] to be informed about changes to [route].
  ///
  /// Going forward, [routeAware] will be informed about qualifying changes
  /// to [route], e.g. when [route] is covered by another route or when [route]
  /// is popped off the [Navigator] stack.
  void subscribe(RouteAware2 routeAware, R route) {
    assert(routeAware != null);
    assert(route != null);
    final Set<RouteAware2> subscribers = _listeners.putIfAbsent(route, () => <RouteAware2>{});
    if (subscribers.add(routeAware)) {
      routeAware.didPush();
    }
  }

  /// Unsubscribe [routeAware].
  ///
  /// [routeAware] is no longer informed about changes to its route. If the given argument was
  /// subscribed to multiple types, this will unregister it (once) from each type.
  void unsubscribe(RouteAware2 routeAware) {
    assert(routeAware != null);
    for (final R route in _listeners.keys) {
      final Set<RouteAware2> subscribers = _listeners[route];
      subscribers?.remove(routeAware);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is R && previousRoute is R) {
      final List<RouteAware2> previousSubscribers = _listeners[previousRoute]?.toList();

      if (previousSubscribers != null) {
        for (final RouteAware2 routeAware in previousSubscribers) {
          routeAware.didPopNext(route);
        }
      }

      final List<RouteAware2> subscribers = _listeners[route]?.toList();

      if (subscribers != null) {
        for (final RouteAware2 routeAware in subscribers) {
          routeAware.didPop();
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route is R && previousRoute is R) {
      final Set<RouteAware2> previousSubscribers = _listeners[previousRoute];

      if (previousSubscribers != null) {
        for (final RouteAware2 routeAware in previousSubscribers) {
          routeAware.didPushNext(route);
        }
      }
    }
  }
}

abstract class RouteAware2 {
  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void didPopNext(Route<dynamic> route) {}

  /// Called when the current route has been pushed.
  void didPush() {}

  /// Called when the current route has been popped off.
  void didPop() {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void didPushNext(Route<dynamic> route) {}
}
