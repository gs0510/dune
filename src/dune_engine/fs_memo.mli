open! Stdune
open Import

(** [init] must be called at initialization. Returns the set of nodes that need
    to be invalidated because they were accessed before [init] was called. *)
val init : dune_file_watcher:Dune_file_watcher.t option -> Memo.Invalidation.t

(** All functions in this module raise a code error when given a path in the
    build directory. *)

(* CR-someday amokhov: Note that currently the scheduler calls [handle] only for
   source paths, because we don't watch external directories. We should try to
   implement at least a partial support for watching external paths. *)

(** Check if a source or external path exists and declare a dependency on it. *)
val path_exists : Path.t -> bool Memo.Build.t

(** Call [Path.stat] on a path and declare a dependency on it. *)
val path_stat :
     Path.t
  -> (Fs_cache.Reduced_stats.t, Unix_error.Detailed.t) result Memo.Build.t

(** Digest the contents of a source or external path and declare a dependency on
    it. *)
val path_digest : Path.t -> Cached_digest.Digest_result.t Memo.Build.t

(** Like [Io.Untracked.with_lexbuf_from_file] but declares a dependency on the
    path. *)
val with_lexbuf_from_file : Path.t -> f:(Lexing.lexbuf -> 'a) -> 'a Memo.Build.t

(** Read the contents of a source or external directory and declare a dependency
    on it. *)
val dir_contents :
  Path.t -> (Fs_cache.Dir_contents.t, Unix_error.Detailed.t) result Memo.Build.t

(** Handle file system event. *)
val handle_fs_event : Dune_file_watcher.Fs_memo_event.t -> Memo.Invalidation.t
