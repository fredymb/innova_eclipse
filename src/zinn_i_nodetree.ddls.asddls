@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Node Tree'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZINN_I_NODETREE as select from zinn_nodetree
association of many to one ZINN_I_NODETREE as _Parent on $projection.Nodeparent = _Parent.Nodeid
{
    key nodeid as Nodeid,
    nodename as Nodename,
    nodeparent as Nodeparent,
    _Parent
}
