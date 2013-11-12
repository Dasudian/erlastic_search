%%%-------------------------------------------------------------------
%%% @author Tristan Sloughter <>
%%% @copyright (C) 2010, Tristan Sloughter
%%% @doc
%%%
%%% @end
%%% Created : 14 Feb 2010 by Tristan Sloughter <>
%%%-------------------------------------------------------------------
-module(erls_utils).
-export([
	comma_separate/1,
	json_encode/1
    ]).


comma_separate([H]) ->
    H;
comma_separate(List) ->
    lists:foldl(fun(String, Acc) ->
                        io_lib:format("~s,~s", [String, Acc])
                end, "", List).


%% To encode utf8-json WITHOUT converting multi-byte utf8-chars into ASCII '\uXXXX'.
json_encode(Data) ->
    (mochijson2:encoder([{utf8, true}]))(Data).


escape_special_characters_id(Query) ->
	NewQuery = escape_special_character(Query,false),
	NewQuery.

escape_special_character([],_)->
	[];
escape_special_character(Query,Bool) when is_binary(Query)->
	escape_special_character(binary_to_list(Query),Bool);
escape_special_character([First|Rest],true) ->
	case First of
		$- ->
			[$\\|[First|escape_special_character(Rest,true)]];
		$% ->
			[First|escape_special_character(Rest,false)];
		$& ->
			[First|escape_special_character(Rest,false)];
		_ ->
			[First|escape_special_character(Rest,true)]
	end;

escape_special_character([First|Rest],false) ->
	case First of
		$: ->
			[First|escape_special_character(Rest,true)];
		_ ->
			[First|escape_special_character(Rest,false)]
	end.