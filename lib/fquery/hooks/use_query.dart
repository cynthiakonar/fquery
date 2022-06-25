import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery/fquery.dart';
import 'package:fquery/fquery/observer.dart';

QueryState<TData, TError> useQuery<TData, TError>(
  String queryKey,
  Future<TData> Function() fetcher, {
  bool enabled = true,
  Duration? refreshInterval,
  RefetchOnMount refetchOnMount = RefetchOnMount.stale,
  double retry = 3,
  Duration retryDelay = const Duration(seconds: 4),
}) {
  final client = useQueryClient();
  final observer = useMemoized(
    () => Observer<TData, TError>(
      queryKey,
      fetcher,
      client: client,
      enabled: enabled,
      refreshInterval: refreshInterval,
      refetchOnMount: refetchOnMount,
      retry: retry,
      retryDelay: retryDelay,
    ),
  );
  // This subscribes to the observer
  useListenable(observer);

  return observer.query.state;
}
