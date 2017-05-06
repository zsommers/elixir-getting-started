defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    {:ok, _} = KV.Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "run create", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error
    assert KVServer.Command.run({:create, "shopping"}, registry) == {:ok, "OK\r\n"}
    assert {:ok, _} = KV.Registry.lookup(registry, "shopping")
  end

  test "run get", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    KV.Bucket.put(bucket, "milk", 1)
    assert KVServer.Command.run({:get, "shopping", "milk"}, registry) == {:ok, "1\r\nOK\r\n"}
  end

  test "run put", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    assert KVServer.Command.run({:put, "shopping", "milk", 1}, registry) == {:ok, "OK\r\n"}
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "run delete", %{registry: registry} do
    bucket = KV.Registry.create(registry, "shopping")
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1

    assert KVServer.Command.run({:delete, "shopping", "milk"}, registry) == {:ok, "OK\r\n"}
    assert KV.Bucket.get(bucket, "milk") == nil
  end
end
